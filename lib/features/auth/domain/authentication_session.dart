import 'package:studanky_flutter_app/core/api/dtos/user_dto.dart';

/// Authentication data shared by the repository and presentation controller.
class AuthenticationSession {
  const AuthenticationSession({this.user, this.jwt});

  final UserDto? user;
  final String? jwt;

  bool get isAuthenticated => user != null && jwt?.isNotEmpty == true;
  bool get isEmailVerified => user?.confirmed ?? false;
}
