import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/interceptors/auth_interceptor.dart';
import 'package:studanky_flutter_app/core/api/interceptors/logging_interceptor.dart';

part 'dio_provider.g.dart';

/// Application-wide [Dio] instance pointed at the Strapi backend, wired with
/// authentication, transient-error retries and redacted logging.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: ApiConfig.defaultHeaders,
      validateStatus: (status) => status != null && status < 400,
    ),
  );

  final retryLogger = Logger('Dio.retry');

  dio.interceptors.addAll([
    AuthInterceptor(dio: dio, ref: ref),
    RetryInterceptor(
      dio: dio,
      logPrint: retryLogger.warning,
      retries: 2,
      retryDelays: const [
        Duration(milliseconds: 300),
        Duration(milliseconds: 800),
      ],
    ),
    LoggingInterceptor(),
  ]);

  ref.onDispose(dio.close);
  return dio;
}
