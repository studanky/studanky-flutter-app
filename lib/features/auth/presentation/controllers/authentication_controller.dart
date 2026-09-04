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
  bool _hasInitialized = false;

  @override
  AuthenticationState build() {
    _repository = ref.watch(authRepositoryProvider);
    final subscription = _repository.sessionChanges.listen(_applySession);
    ref.onDispose(subscription.cancel);

    if (!_hasInitialized) {
      _hasInitialized = true;
      unawaited(_initialize());
    }
    return const AuthenticationState(isLoading: true);
  }

  void _applySession(AuthenticationSession session) {
    state = AuthenticationState.fromSession(
      session,
      isInitialized: state.isInitialized,
    );
  }

  Future<void> _initialize() async {
    try {
      final session = await _repository.restore();
      state = AuthenticationState.fromSession(session, isInitialized: true);
    } finally {
      state = state.copyWith(isInitialized: true, isLoading: false);
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
