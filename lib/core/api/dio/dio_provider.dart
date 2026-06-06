import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/interceptors/auth_interceptor.dart';
import 'package:studanky_flutter_app/core/api/interceptors/bearer_token_interceptor.dart';
import 'package:studanky_flutter_app/core/api/interceptors/logging_interceptor.dart';

part 'dio_provider.g.dart';

BaseOptions _strapiBaseOptions() => BaseOptions(
  baseUrl: ApiConfig.baseUrl,
  connectTimeout: ApiConfig.connectTimeout,
  receiveTimeout: ApiConfig.receiveTimeout,
  sendTimeout: ApiConfig.sendTimeout,
  headers: ApiConfig.defaultHeaders,
  validateStatus: (status) => status != null && status < 400,
);

RetryInterceptor _retryInterceptor(Dio dio) => RetryInterceptor(
  dio: dio,
  logPrint: Logger('Dio.retry').warning,
  retries: 2,
  retryDelays: const [Duration(milliseconds: 300), Duration(milliseconds: 800)],
);

/// Application-wide [Dio] instance pointed at the Strapi backend, wired with
/// authentication (token injection + 401 re-auth), transient-error retries and
/// redacted logging.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(_strapiBaseOptions());

  dio.interceptors.addAll([
    AuthInterceptor(dio: dio, ref: ref),
    _retryInterceptor(dio),
    LoggingInterceptor(),
  ]);

  ref.onDispose(dio.close);
  return dio;
}

/// Dedicated [Dio] for the authentication endpoints (login, register, refresh,
/// `/users/me`).
///
/// Intentionally **separate** from [dio] and wired with the lightweight
/// [BearerTokenInterceptor] instead of [AuthInterceptor]. This breaks the
/// circular dependency that arose when the auth service (reached via the main
/// Dio's interceptor) also depended on the main Dio: the auth stack now only
/// depends on the dependency-free token holder. It also prevents a reauth loop
/// — a failed login must never trigger another re-authentication.
@Riverpod(keepAlive: true)
Dio authDio(Ref ref) {
  final dio = Dio(_strapiBaseOptions());

  dio.interceptors.addAll([
    BearerTokenInterceptor(ref),
    _retryInterceptor(dio),
    LoggingInterceptor(),
  ]);

  ref.onDispose(dio.close);
  return dio;
}
