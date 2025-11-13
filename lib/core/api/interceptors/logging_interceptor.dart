import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class LoggingInterceptor extends Interceptor {
  final Logger _logger = Logger('ApiClient');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger
      ..info('REQUEST: ${options.method} ${options.uri}')
      ..fine('Headers: ${options.headers}');

    if (options.data != null) {
      _logger.fine('Body: ${options.data}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger
      ..info('RESPONSE: ${response.statusCode} ${response.requestOptions.uri}')
      ..fine('Response data: ${response.data}');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger
      ..severe('ERROR: ${err.message}')
      ..severe(
        'Request: ${err.requestOptions.method} ${err.requestOptions.uri}',
      );

    if (err.response != null) {
      _logger.severe(
        'Response: ${err.response?.statusCode} ${err.response?.data}',
      );
    }
    try {
      super.onError(err, handler);
    } catch (e) {
      _logger.severe('Error in onError: $e');
    }
  }
}
