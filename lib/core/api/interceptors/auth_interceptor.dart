import 'dart:async';

import 'package:dio/dio.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/services/auth_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio, this._authService);

  static const _retryExtraKey = 'ersta__retried';

  final Dio _dio;
  final AuthService _authService;
  Completer<void>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldSkipAuthorization(options)) {
      handler.next(options);
      return;
    }

    final token = _authService.currentToken;

    if (token != null && token.isNotEmpty) {
      options.headers.addAll(ApiConfig.authHeaders(token));
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldAttemptRefresh(err)) {
      handler.next(err);
      return;
    }

    try {
      await _ensureAuthenticated();
    } catch (_) {
      handler.next(err);
      return;
    }

    final token = _authService.currentToken;
    if (token == null || token.isEmpty) {
      handler.next(err);
      return;
    }

    final requestOptions = err.requestOptions;
    requestOptions.headers
      ..remove('Authorization')
      ..addAll(ApiConfig.authHeaders(token));
    requestOptions.extra[_retryExtraKey] = true;

    try {
      final response = await _dio.fetch<dynamic>(requestOptions);
      handler.resolve(response);
    } catch (_) {
      handler.next(err);
    } finally {
      requestOptions.extra.remove(_retryExtraKey);
    }
  }

  Future<void> _ensureAuthenticated() {
    final existingCompleter = _refreshCompleter;
    if (existingCompleter != null) {
      return existingCompleter.future;
    }

    final completer = Completer<void>();
    _refreshCompleter = completer;

    () async {
      try {
        await _authService.reAuthenticate();
        completer.complete();
      } catch (error, stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      } finally {
        _refreshCompleter = null;
      }
    }();

    return completer.future;
  }

  bool _shouldAttemptRefresh(DioException err) {
    if (err.response?.statusCode != 401) {
      return false;
    }

    final options = err.requestOptions;

    if (_hasRetried(options)) {
      return false;
    }

    if (_shouldSkipAuthorization(options)) {
      return false;
    }

    return true;
  }

  bool _hasRetried(RequestOptions options) =>
      options.extra[_retryExtraKey] == true;

  bool _shouldSkipAuthorization(RequestOptions options) {
    bool matchesEndpoint(String endpoint) =>
        options.path.endsWith(endpoint) || options.uri.path.endsWith(endpoint);

    return matchesEndpoint(ApiConfig.authEndpoint) ||
        matchesEndpoint(ApiConfig.registerEndpoint) ||
        matchesEndpoint(ApiConfig.generatePasswordEndpoint) ||
        matchesEndpoint(ApiConfig.changePasswordEndpoint) ||
        matchesEndpoint(ApiConfig.sendEmailConfirmationEndpoint);
  }
}
