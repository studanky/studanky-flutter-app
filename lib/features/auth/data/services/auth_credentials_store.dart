import 'package:studanky_flutter_app/core/api/dtos/user_dto.dart';

typedef StoredCredentials = ({String email, String password});

/// Persistent boundary for authentication secrets and the cached user.
abstract interface class AuthCredentialsStore {
  Future<StoredCredentials?> readCredentials();

  Future<UserDto?> readUser();

  Future<void> saveAuthenticated({
    required String email,
    required String password,
    required UserDto user,
  });

  Future<void> saveRegistration({
    required String email,
    required String password,
    required UserDto user,
  });

  Future<void> updateUser(UserDto user);

  Future<void> clear();
}
