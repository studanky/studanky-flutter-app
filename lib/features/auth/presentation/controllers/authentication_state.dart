import 'package:studanky_flutter_app/core/api/dtos/user_dto.dart';
import 'package:studanky_flutter_app/features/auth/domain/authentication_session.dart';

const _unset = Object();

/// Immutable view state exposed by the authentication controller.
class AuthenticationState {
  const AuthenticationState({
    this.isLoading = false,
    this.isUserAuthenticated = false,
    this.isEmailVerified = false,
    this.isInitialized = false,
    this.user,
    this.error,
  });

  factory AuthenticationState.fromSession(
    AuthenticationSession session, {
    bool isInitialized = false,
  }) => AuthenticationState(
    isUserAuthenticated: session.isAuthenticated,
    isEmailVerified: session.isEmailVerified,
    isInitialized: isInitialized,
    user: session.user,
  );

  final bool isLoading;
  final bool isUserAuthenticated;
  final bool isEmailVerified;
  final bool isInitialized;
  final UserDto? user;
  final String? error;

  bool get isAuthenticationCompleted => isUserAuthenticated && isEmailVerified;

  AuthenticationState copyWith({
    bool? isLoading,
    bool? isUserAuthenticated,
    bool? isEmailVerified,
    bool? isInitialized,
    Object? user = _unset,
    Object? error = _unset,
  }) => AuthenticationState(
    isLoading: isLoading ?? this.isLoading,
    isUserAuthenticated: isUserAuthenticated ?? this.isUserAuthenticated,
    isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    isInitialized: isInitialized ?? this.isInitialized,
    user: identical(user, _unset) ? this.user : user as UserDto?,
    error: identical(error, _unset) ? this.error : error as String?,
  );
}
