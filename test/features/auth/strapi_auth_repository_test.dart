import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/core/api/dtos/user_dto.dart';
import 'package:studanky_flutter_app/features/auth/data/repositories/strapi_auth_repository.dart';
import 'package:studanky_flutter_app/features/auth/data/services/auth_api.dart';
import 'package:studanky_flutter_app/features/auth/data/services/auth_credentials_store.dart';
import 'package:studanky_flutter_app/features/auth/domain/models/auth_models.dart';

final _user = UserDto(
  id: 1,
  username: 'tester',
  email: 'test@example.com',
  confirmed: true,
  blocked: false,
);

class _FakeAuthApi implements AuthApi {
  _FakeAuthApi({required this.loginHandler});

  final Future<AuthResponse> Function(LoginRequest request) loginHandler;

  @override
  Future<AuthResponse> login(LoginRequest request) => loginHandler(request);

  @override
  Future<AuthResponse> register(RegisterRequest request) =>
      throw UnimplementedError();

  @override
  Future<void> sendEmailConfirmation(SendEmailConfirmationRequest request) =>
      throw UnimplementedError();

  @override
  Future<void> generatePassword(GeneratePasswordRequest request) =>
      throw UnimplementedError();

  @override
  Future<AuthResponse> changePassword(ChangePasswordRequest request) =>
      throw UnimplementedError();

  @override
  Future<UserDto> getCurrentUser() => throw UnimplementedError();
}

class _MemoryCredentialsStore implements AuthCredentialsStore {
  StoredCredentials? credentials;
  UserDto? user;
  bool cleared = false;

  @override
  Future<StoredCredentials?> readCredentials() async => credentials;

  @override
  Future<UserDto?> readUser() async => user;

  @override
  Future<void> saveAuthenticated({
    required String email,
    required String password,
    required UserDto user,
  }) async {
    credentials = (email: email, password: password);
    this.user = user;
  }

  @override
  Future<void> saveRegistration({
    required String email,
    required String password,
    required UserDto user,
  }) => saveAuthenticated(email: email, password: password, user: user);

  @override
  Future<void> updateUser(UserDto user) async => this.user = user;

  @override
  Future<void> clear() async {
    credentials = null;
    user = null;
    cleared = true;
  }
}

void main() {
  test(
    'login persists credentials, publishes session and updates token',
    () async {
      final store = _MemoryCredentialsStore();
      String? token;
      final repository = StrapiAuthRepository(
        api: _FakeAuthApi(
          loginHandler: (_) async => AuthResponse(jwt: 'jwt-123', user: _user),
        ),
        credentialsStore: store,
        updateToken: (value) => token = value,
      );
      addTearDown(repository.dispose);
      final publishedSession = repository.sessionChanges.first;

      await repository.login(
        LoginRequest(identifier: _user.email, password: 'secret'),
      );

      expect(store.credentials, (email: _user.email, password: 'secret'));
      expect(store.user, same(_user));
      expect(repository.currentSession.isAuthenticated, isTrue);
      expect(token, 'jwt-123');
      expect((await publishedSession).jwt, 'jwt-123');
    },
  );

  test('restore retains cached user when silent login fails', () async {
    final store = _MemoryCredentialsStore()
      ..credentials = (email: _user.email, password: 'old-secret')
      ..user = _user;
    String? token = 'stale';
    final repository = StrapiAuthRepository(
      api: _FakeAuthApi(
        loginHandler: (_) => throw DioException(
          requestOptions: RequestOptions(path: '/auth/local'),
          type: DioExceptionType.connectionError,
        ),
      ),
      credentialsStore: store,
      updateToken: (value) => token = value,
    );
    addTearDown(repository.dispose);

    final session = await repository.restore();

    expect(session.user, same(_user));
    expect(session.isAuthenticated, isFalse);
    expect(token, isNull);
  });

  test('logout clears persisted and in-memory session', () async {
    final store = _MemoryCredentialsStore();
    String? token;
    final repository = StrapiAuthRepository(
      api: _FakeAuthApi(
        loginHandler: (_) async => AuthResponse(jwt: 'jwt-123', user: _user),
      ),
      credentialsStore: store,
      updateToken: (value) => token = value,
    );
    addTearDown(repository.dispose);
    await repository.login(
      LoginRequest(identifier: _user.email, password: 'secret'),
    );

    await repository.logout();

    expect(store.cleared, isTrue);
    expect(repository.currentSession.isAuthenticated, isFalse);
    expect(repository.currentSession.user, isNull);
    expect(token, isNull);
  });
}
