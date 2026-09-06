import 'package:dio/dio.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';

/// Attaches the current bearer token (if any) to outgoing requests.
///
/// Unlike `AuthInterceptor` this does **not** perform 401 re-authentication —
/// it is meant for the auth-stack Dio, which must never trigger a reauth loop
/// on its own login/refresh calls.
class BearerTokenInterceptor extends Interceptor {
  BearerTokenInterceptor(this._readToken);

  final String? Function() _readToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _readToken();
    if (token != null && token.isNotEmpty) {
      options.headers.addAll(ApiConfig.authHeaders(token));
    }
    handler.next(options);
  }
}
