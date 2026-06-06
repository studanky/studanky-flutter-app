import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/services/auth_token_provider.dart';

/// Attaches the current bearer token (if any) to outgoing requests.
///
/// Unlike `AuthInterceptor` this does **not** perform 401 re-authentication —
/// it is meant for the auth-stack Dio, which must never trigger a reauth loop
/// on its own login/refresh calls. The token is read from the dependency-free
/// [authTokenProvider] so this interceptor adds no provider edges back to any
/// Dio (see auth_token_provider.dart).
class BearerTokenInterceptor extends Interceptor {
  BearerTokenInterceptor(this._ref);

  final Ref _ref;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _ref.read(authTokenProvider);
    if (token != null && token.isNotEmpty) {
      options.headers.addAll(ApiConfig.authHeaders(token));
    }
    handler.next(options);
  }
}
