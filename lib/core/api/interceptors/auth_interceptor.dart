import 'dart:async';

import 'package:dio/dio.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';

/// Injects the bearer token on outgoing requests and, on a 401, performs a
/// single de-duplicated re-authentication before replaying the request.
///
/// Dependencies are injected as narrow callbacks, keeping this network utility
/// independent from Riverpod and the auth presentation layer.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.dio,
    required this.readToken,
    required this.reAuthenticate,
  });

  static const _retryExtraKey = 'studanky__retried';

  final Dio dio;
  final String? Function() readToken;
  final Future<void> Function() reAuthenticate;
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

    final token = readToken();

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

    final token = readToken();
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
      final response = await dio.fetch<dynamic>(requestOptions);
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
        await reAuthenticate();
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

    // NOTE: change-password is intentionally NOT skipped — Strapi requires the
    // user to be authenticated (Authorization: Bearer <jwt>) for that endpoint.
    return matchesEndpoint(ApiConfig.authEndpoint) ||
        matchesEndpoint(ApiConfig.registerEndpoint) ||
        matchesEndpoint(ApiConfig.generatePasswordEndpoint) ||
        matchesEndpoint(ApiConfig.sendEmailConfirmationEndpoint);
  }
}
