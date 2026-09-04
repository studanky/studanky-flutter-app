import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/dtos/user_dto.dart';
import 'package:studanky_flutter_app/core/api/exceptions/api_exceptions.dart';
import 'package:studanky_flutter_app/features/auth/data/repositories/auth_repository.dart';
import 'package:studanky_flutter_app/features/auth/data/services/auth_api.dart';
import 'package:studanky_flutter_app/features/auth/data/services/auth_credentials_store.dart';
import 'package:studanky_flutter_app/features/auth/data/services/auth_token_provider.dart';
import 'package:studanky_flutter_app/features/auth/data/services/secure_auth_credentials_store.dart';
import 'package:studanky_flutter_app/features/auth/domain/authentication_session.dart';
import 'package:studanky_flutter_app/features/auth/domain/models/auth_models.dart';
import 'package:studanky_flutter_app/features/auth/domain/session_refresher.dart';

part 'strapi_auth_repository.g.dart';

/// Strapi-backed [AuthRepository] with secure local session persistence.
class StrapiAuthRepository implements AuthRepository {
  StrapiAuthRepository({
    required this.api,
    required this.credentialsStore,
    required this.updateToken,
  });

  final AuthApi api;
  final AuthCredentialsStore credentialsStore;
  final void Function(String? token) updateToken;
  final StreamController<AuthenticationSession> _sessionChanges =
      StreamController<AuthenticationSession>.broadcast();

  AuthenticationSession _currentSession = const AuthenticationSession();

  @override
  AuthenticationSession get currentSession => _currentSession;

  @override
  Stream<AuthenticationSession> get sessionChanges => _sessionChanges.stream;

  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (exception) {
      throw ApiExceptionHandler.handleDioException(exception);
    }
  }

  void _publish(AuthenticationSession session) {
    _currentSession = session;
    updateToken(session.jwt);
    _sessionChanges.add(session);
  }

  @override
  Future<AuthenticationSession> restore() async {
    final credentials = await credentialsStore.readCredentials();
    if (credentials == null) {
      _publish(const AuthenticationSession());
      return _currentSession;
    }

    UserDto? cachedUser;
    try {
      cachedUser = await credentialsStore.readUser();
    } on Object {
      await credentialsStore.clear();
      _publish(const AuthenticationSession());
      return _currentSession;
    }

    try {
      await _authenticate(credentials);
    } on Object {
      _publish(AuthenticationSession(user: cachedUser));
    }
    return _currentSession;
  }

  @override
  Future<AuthResponse> login(LoginRequest request) =>
      _authenticate((email: request.identifier, password: request.password));

  Future<AuthResponse> _authenticate(StoredCredentials credentials) async {
    final response = await _guard(
      () => api.login(
        LoginRequest(
          identifier: credentials.email,
          password: credentials.password,
        ),
      ),
    );
    await credentialsStore.saveAuthenticated(
      email: credentials.email,
      password: credentials.password,
      user: response.user,
    );
    _publish(AuthenticationSession(user: response.user, jwt: response.jwt));
    return response;
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _guard(() => api.register(request));
    if (response.jwt == null) {
      await credentialsStore.saveRegistration(
        email: request.email,
        password: request.password,
        user: response.user,
      );
    } else {
      await credentialsStore.saveAuthenticated(
        email: request.email,
        password: request.password,
        user: response.user,
      );
    }
    _publish(AuthenticationSession(user: response.user, jwt: response.jwt));
    return response;
  }

  @override
  Future<void> sendEmailConfirmation(SendEmailConfirmationRequest request) =>
      _guard(() => api.sendEmailConfirmation(request));

  @override
  Future<void> generatePassword(GeneratePasswordRequest request) =>
      _guard(() => api.generatePassword(request));

  @override
  Future<AuthResponse> changePassword(ChangePasswordRequest request) async {
    final response = await _guard(() => api.changePassword(request));
    final credentials = await credentialsStore.readCredentials();
    if (credentials != null && response.jwt != null) {
      await credentialsStore.saveAuthenticated(
        email: credentials.email,
        password: request.password,
        user: response.user,
      );
    }
    _publish(AuthenticationSession(user: response.user, jwt: response.jwt));
    return response;
  }

  @override
  Future<UserDto> getCurrentUser() async {
    final user = await _guard(api.getCurrentUser);
    await credentialsStore.updateUser(user);
    _publish(AuthenticationSession(user: user, jwt: currentSession.jwt));
    return user;
  }

  @override
  Future<void> logout() async {
    await credentialsStore.clear();
    _publish(const AuthenticationSession());
  }

  @override
  Future<void> reAuthenticate() async {
    final credentials = await credentialsStore.readCredentials();
    if (credentials == null) {
      throw const UnauthorizedException(message: 'No stored credentials.');
    }
    await _authenticate(credentials);
  }

  void dispose() => _sessionChanges.close();
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final repository = StrapiAuthRepository(
    api: ref.watch(authApiProvider),
    credentialsStore: ref.watch(authCredentialsStoreProvider),
    updateToken: ref.read(authTokenProvider.notifier).setToken,
  );
  ref.onDispose(repository.dispose);
  return repository;
}

@Riverpod(keepAlive: true)
SessionRefresher sessionRefresher(Ref ref) => ref.watch(authRepositoryProvider);
