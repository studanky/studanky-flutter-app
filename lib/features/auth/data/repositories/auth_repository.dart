import 'package:studanky_flutter_app/core/api/dtos/user_dto.dart';
import 'package:studanky_flutter_app/features/auth/domain/authentication_session.dart';
import 'package:studanky_flutter_app/features/auth/domain/models/auth_models.dart';
import 'package:studanky_flutter_app/features/auth/domain/session_refresher.dart';

/// Single source of truth for the authenticated session.
abstract interface class AuthRepository implements SessionRefresher {
  AuthenticationSession get currentSession;

  Stream<AuthenticationSession> get sessionChanges;

  Future<AuthenticationSession> restore();

  Future<AuthResponse> login(LoginRequest request);

  Future<AuthResponse> register(RegisterRequest request);

  Future<void> sendEmailConfirmation(SendEmailConfirmationRequest request);

  Future<void> generatePassword(GeneratePasswordRequest request);

  Future<AuthResponse> changePassword(ChangePasswordRequest request);

  Future<UserDto> getCurrentUser();

  Future<void> logout();
}
