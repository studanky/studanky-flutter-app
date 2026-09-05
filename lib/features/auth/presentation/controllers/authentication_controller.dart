import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/dtos/user_dto.dart';
import 'package:studanky_flutter_app/core/api/exceptions/api_exceptions.dart';
import 'package:studanky_flutter_app/features/auth/data/repositories/auth_repository.dart';
import 'package:studanky_flutter_app/features/auth/data/repositories/strapi_auth_repository.dart';
import 'package:studanky_flutter_app/features/auth/domain/authentication_session.dart';
import 'package:studanky_flutter_app/features/auth/domain/models/auth_models.dart';
import 'package:studanky_flutter_app/features/auth/presentation/controllers/authentication_state.dart';

part 'authentication_controller.g.dart';

/// Presentation controller for authentication flows.
@Riverpod(keepAlive: true)
class AuthenticationController extends _$AuthenticationController {
  late AuthRepository _repository;

  @override
  AuthenticationState build() {
    final repository = ref.watch(authRepositoryProvider);
    _repository = repository;
    final subscription = repository.sessionChanges.listen(
      (session) => _applySession(repository, session),
    );
    ref.onDispose(subscription.cancel);

    unawaited(_initialize(repository));
    return const AuthenticationState(isLoading: true);
  }

  void _applySession(AuthRepository repository, AuthenticationSession session) {
    if (!identical(_repository, repository)) return;
    state = AuthenticationState.fromSession(
      session,
      isInitialized: state.isInitialized,
    );
  }

  Future<void> _initialize(AuthRepository repository) async {
    try {
      final session = await repository.restore();
      if (!identical(_repository, repository)) return;
      state = AuthenticationState.fromSession(session, isInitialized: true);
    } catch (error) {
      if (!identical(_repository, repository)) return;
      state = state.copyWith(error: error.toString());
    } finally {
      if (identical(_repository, repository)) {
        state = state.copyWith(isInitialized: true, isLoading: false);
      }
    }
  }

  Future<AuthResponse> login(LoginRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      return await _repository.login(request);
    } catch (error) {
      if (error is ValidationException &&
          error.statusCode == 400 &&
          error.strapiErrorType == StrapiErrorType.applicationError) {
        await _repository.sendEmailConfirmation(
          SendEmailConfirmationRequest(email: request.identifier),
        );
      }
      state = state.copyWith(isLoading: false, error: error.toString());
      rethrow;
    }
  }

  Future<AuthResponse> register(RegisterRequest request) =>
      _run(() => _repository.register(request));

  Future<void> sendEmailConfirmation(SendEmailConfirmationRequest request) =>
      _repository.sendEmailConfirmation(request);

  Future<void> generatePassword(GeneratePasswordRequest request) =>
      _repository.generatePassword(request);

  Future<AuthResponse> changePassword(ChangePasswordRequest request) =>
      _run(() => _repository.changePassword(request));

  Future<UserDto> getCurrentUser() => _run(_repository.getCurrentUser);

  Future<void> logout() => _run(_repository.logout);

  Future<T> _run<T>(Future<T> Function() operation) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      return await operation();
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
      rethrow;
    }
  }
}
