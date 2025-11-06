import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:studanky_flutter_app/core/api/bos/user_bo.dart';
import 'package:studanky_flutter_app/core/api/clients/api_client.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/exceptions/api_exceptions.dart';
import 'package:studanky_flutter_app/core/api/models/auth_models.dart';

part 'auth_service.freezed.dart';

@freezed
abstract class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    @Default(false) bool isLoading,
    @Default(false) bool isUserAuthenticated,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isInitialized,
    UserBO? user,
    String? error,
  }) = _AuthenticationState;

  const AuthenticationState._();

  // Computed properties
  bool get isAuthenticationCompleted => isUserAuthenticated && isEmailVerified;
}

class AuthService extends Notifier<AuthenticationState> {
  AuthService();

  late ApiClient _apiClient;
  late FlutterSecureStorage _secureStorage;
  bool _hasInitialized = false;

  String? _currentJWT;
  String? get currentToken => _currentJWT;

  @override
  AuthenticationState build() {
    _apiClient = ref.watch(apiClientProvider);
    _secureStorage = ref.watch(secureStorageProvider);

    if (!_hasInitialized) {
      _hasInitialized = true;
      _apiClient.setupInterceptors(this);
      unawaited(_initialize());
    }

    return const AuthenticationState(isLoading: true);
  }

  Future<AuthResponse> login(LoginRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.post(
        ApiConfig.authEndpoint,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);

      await _saveAuthData(authResponse, request.identifier, request.password);
      _updateState();
      return authResponse;
    } catch (e) {
      // Unconfirmed email
      if (e is ValidationException &&
          e.statusCode == 400 &&
          e.strapiErrorType == StrapiErrorType.applicationError) {
        await sendEmailConfirmation(
          SendEmailConfirmationRequest(email: request.identifier),
        );
      }

      // Set error state and rethrow
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.post(
        ApiConfig.registerEndpoint,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Handle registration response based on email verification settings
      if (authResponse.jwt != null) {
        // JWT provided - email verification is disabled or user is auto-confirmed
        await _saveAuthData(authResponse, request.email, request.password);
      } else {
        // No JWT - email verification is enabled, user needs to confirm email
        // Store credentials and user data, but no JWT
        await _saveRegistrationData(
          authResponse.user,
          request.email,
          request.password,
        );
        state = state.copyWith(user: authResponse.user);
      }

      _updateState();
      return authResponse;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> sendEmailConfirmation(
    SendEmailConfirmationRequest request,
  ) async {
    await _apiClient.post(
      ApiConfig.sendEmailConfirmationEndpoint,
      data: request.toJson(),
    );
  }

  Future<void> generatePassword(GeneratePasswordRequest request) async {
    await _apiClient.post(
      ApiConfig.generatePasswordEndpoint,
      data: request.toJson(),
    );
  }

  Future<AuthResponse> changePassword(ChangePasswordRequest request) async {
    final response = await _apiClient.post(
      ApiConfig.changePasswordEndpoint,
      data: request.toJson(),
    );

    final authResponse = AuthResponse.fromJson(response.data);
    // Update stored credentials with new password
    final email = await _secureStorage.read(key: ApiConfig.credentialsEmailKey);
    if (email != null && authResponse.jwt != null) {
      await _saveAuthData(authResponse, email, request.password);
    }
    _updateState();
    return authResponse;
  }

  Future<UserBO> getCurrentUser() async {
    final response = await _apiClient.get(ApiConfig.meEndpoint);
    final user = UserBO.fromJson(response.data);

    // Update local state with fresh server data
    state = state.copyWith(user: user);
    _updateState();

    return user;
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _clearAuthData();
      _currentJWT = null;

      state = const AuthenticationState(isInitialized: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Re-authenticate using stored credentials
  /// Returns true if successful, false if no credentials stored or auth failed
  Future<void> reAuthenticate() async {
    final email = await _secureStorage.read(key: ApiConfig.credentialsEmailKey);
    final password = await _secureStorage.read(
      key: ApiConfig.credentialsPasswordKey,
    );

    if (email == null || password == null) {
      throw Exception();
    }

    try {
      await login(LoginRequest(identifier: email, password: password));
    } catch (e) {
      rethrow;
    }
  }

  /// Initialize auth service - check for stored credentials and attempt authentication
  Future<void> _initialize() async {
    try {
      final email = await _secureStorage.read(
        key: ApiConfig.credentialsEmailKey,
      );
      final password = await _secureStorage.read(
        key: ApiConfig.credentialsPasswordKey,
      );
      final userJson = await _secureStorage.read(key: ApiConfig.userKey);

      if (email != null && password != null) {
        // Load user data from storage first (needed for state logic)
        if (userJson != null) {
          try {
            final user = UserBO.fromJson(jsonDecode(userJson));
            state = state.copyWith(user: user);
          } catch (e) {
            // If user data is corrupted, clear everything
            await _clearAuthData();
            state = const AuthenticationState(isInitialized: true);
            return;
          }
        }

        // Try to re-authenticate - login method will handle JWT and state updates
        await reAuthenticate();

        // If reAuthenticate failed but we have user data, ensure state is updated
        // (this handles the case where email is not verified)
        if (_currentJWT == null && state.user != null) {
          _updateState();
        }
      } else {
        // No credentials stored
        _updateState();
      }
    } finally {
      // Mark as initialized
      state = state.copyWith(isInitialized: true, isLoading: false);
    }
  }

  Future<void> _saveAuthData(
    AuthResponse authResponse,
    String email,
    String password,
  ) async {
    // Store JWT and user in memory
    _currentJWT = authResponse.jwt;

    // Store credentials and user data in secure storage for persistence
    await _secureStorage.write(
      key: ApiConfig.credentialsEmailKey,
      value: email,
    );
    await _secureStorage.write(
      key: ApiConfig.credentialsPasswordKey,
      value: password,
    );
    await _secureStorage.write(
      key: ApiConfig.userKey,
      value: jsonEncode(authResponse.user.toJson()),
    );

    // Update state
    state = state.copyWith(user: authResponse.user);
  }

  Future<void> _saveRegistrationData(
    UserBO user,
    String email,
    String password,
  ) async {
    // Store credentials and user data without JWT (for email verification scenario)
    await _secureStorage.write(
      key: ApiConfig.credentialsEmailKey,
      value: email,
    );
    await _secureStorage.write(
      key: ApiConfig.credentialsPasswordKey,
      value: password,
    );
    await _secureStorage.write(
      key: ApiConfig.userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  Future<void> _clearAuthData() async {
    await _secureStorage.delete(key: ApiConfig.credentialsEmailKey);
    await _secureStorage.delete(key: ApiConfig.credentialsPasswordKey);
    await _secureStorage.delete(key: ApiConfig.userKey);
  }

  void _updateState() {
    final hasUser = state.user != null;
    final isEmailVerified = state.user?.confirmed ?? false;

    state = state.copyWith(
      isUserAuthenticated: hasUser,
      isEmailVerified: isEmailVerified,
      isLoading: false,
      error: null,
    );
  }
}

// Secure Storage instance with platform-specific options aligned with v9 API
const _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
    sharedPreferencesName: ApiConfig.secureStorageAndroidSharedPreferencesName,
    preferencesKeyPrefix: ApiConfig.secureStorageAndroidPreferencesKeyPrefix,
  ),
  iOptions: IOSOptions(
    accountName: ApiConfig.secureStorageIosAccountName,
    accessibility: ApiConfig.secureStorageIosAccessibility,
    synchronizable: ApiConfig.secureStorageIosSynchronizable,
  ),
);

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return _secureStorage;
});

final authServiceProvider = NotifierProvider<AuthService, AuthenticationState>(
  AuthService.new,
);
