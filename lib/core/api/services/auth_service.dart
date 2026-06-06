import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/dio/dio_provider.dart';
import 'package:studanky_flutter_app/core/api/dtos/user_dto.dart';
import 'package:studanky_flutter_app/core/api/exceptions/api_exceptions.dart';
import 'package:studanky_flutter_app/core/api/models/auth_models.dart';
import 'package:studanky_flutter_app/core/api/services/auth_api.dart';

part 'auth_service.freezed.dart';
part 'auth_service.g.dart';

@freezed
abstract class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    @Default(false) bool isLoading,
    @Default(false) bool isUserAuthenticated,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isInitialized,
    UserDto? user,
    String? error,
  }) = _AuthenticationState;

  const AuthenticationState._();

  // Computed properties
  bool get isAuthenticationCompleted => isUserAuthenticated && isEmailVerified;
}

@Riverpod(keepAlive: true)
class AuthService extends _$AuthService {
  late AuthApi _authApi;
  late FlutterSecureStorage _secureStorage;
  bool _hasInitialized = false;

  String? _currentJWT;
  String? get currentToken => _currentJWT;

  @override
  AuthenticationState build() {
    _authApi = ref.watch(authApiProvider);
    _secureStorage = ref.watch(secureStorageProvider);

    if (!_hasInitialized) {
      _hasInitialized = true;
      unawaited(_initialize());
    }

    return const AuthenticationState(isLoading: true);
  }

  /// Converts raw [DioException]s thrown by the retrofit client into typed
  /// [ApiException]s so callers can branch on the failure semantics.
  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (exception) {
      throw ApiExceptionHandler.handleDioException(exception);
    }
  }

  Future<AuthResponse> login(LoginRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authResponse = await _guard(() => _authApi.login(request));

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
      final authResponse = await _guard(() => _authApi.register(request));

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
    await _guard(() => _authApi.sendEmailConfirmation(request));
  }

  Future<void> generatePassword(GeneratePasswordRequest request) async {
    await _guard(() => _authApi.generatePassword(request));
  }

  Future<AuthResponse> changePassword(ChangePasswordRequest request) async {
    final authResponse = await _guard(() => _authApi.changePassword(request));
    // Update stored credentials with new password
    final email = await _secureStorage.read(key: ApiConfig.credentialsEmailKey);
    if (email != null && authResponse.jwt != null) {
      await _saveAuthData(authResponse, email, request.password);
    }
    _updateState();
    return authResponse;
  }

  Future<UserDto> getCurrentUser() async {
    final user = await _guard(() => _authApi.getCurrentUser());

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

  /// Re-authenticate using stored credentials.
  ///
  /// Throws if no credentials are stored or authentication fails.
  Future<void> reAuthenticate() async {
    final email = await _secureStorage.read(key: ApiConfig.credentialsEmailKey);
    final password = await _secureStorage.read(
      key: ApiConfig.credentialsPasswordKey,
    );

    if (email == null || password == null) {
      throw const UnauthorizedException(message: 'No stored credentials.');
    }

    await login(LoginRequest(identifier: email, password: password));
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
            final user = UserDto.fromJson(
              jsonDecode(userJson) as Map<String, dynamic>,
            );
            state = state.copyWith(user: user);
          } catch (e) {
            // If user data is corrupted, clear everything
            await _clearAuthData();
            state = const AuthenticationState(isInitialized: true);
            return;
          }
        }

        // Try to re-authenticate - login method will handle JWT and state updates
        try {
          await reAuthenticate();
        } catch (_) {
          // Re-authentication may legitimately fail (e.g. unconfirmed email);
          // keep any user data loaded above so the UI can react accordingly.
        }

        // Re-auth did not yield a token (failed, or email not yet verified):
        // refresh the derived state so it reflects the unauthenticated session
        // while keeping the cached user available for the UI.
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

    // SECURITY: Strapi users-permissions has no refresh-token flow out of the
    // box, so the raw password is persisted in the platform secure store
    // (iOS Keychain / Android Keystore) to support silent re-authentication on
    // 401. This is a known trade-off; migrating to a refresh-token plugin would
    // let us drop password persistence. See API_DOCUMENTATION.md.
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
    UserDto user,
    String email,
    String password,
  ) async {
    // Store credentials and user data without JWT (for email verification scenario)
    // SECURITY: see note in [_saveAuthData] regarding password persistence.
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
    // A user is only considered authenticated when we actually hold a valid
    // JWT. Relying on a cached user alone would let the UI treat a session as
    // active after a failed re-auth (offline, revoked/expired token, password
    // changed elsewhere), while every API call would then fail with 401.
    final hasSession = state.user != null && _currentJWT != null;
    final isEmailVerified = state.user?.confirmed ?? false;

    state = state.copyWith(
      isUserAuthenticated: hasSession,
      isEmailVerified: isEmailVerified,
      isLoading: false,
      error: null,
    );
  }
}

/// Retrofit-backed authentication API bound to the shared [Dio] client.
@Riverpod(keepAlive: true)
AuthApi authApi(Ref ref) => AuthApi(ref.watch(dioProvider));

// Secure Storage instance with platform-specific options aligned with v10 API
const _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    storageNamespace: ApiConfig.secureStorageAndroidSharedPreferencesName,
    preferencesKeyPrefix: ApiConfig.secureStorageAndroidPreferencesKeyPrefix,
  ),
  iOptions: IOSOptions(
    accountName: ApiConfig.secureStorageIosAccountName,
    accessibility: ApiConfig.secureStorageIosAccessibility,
    synchronizable: ApiConfig.secureStorageIosSynchronizable,
  ),
);

@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) => _secureStorage;
