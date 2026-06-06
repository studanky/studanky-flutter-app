import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

/// Logs requests/responses through the `logging` package configured in
/// `main.dart`. Sensitive data is redacted before it ever reaches the logs:
/// secret headers (e.g. `Authorization`), secret query parameters (e.g. the
/// Mapy.com `apikey`) and secret body fields (passwords, tokens).
class LoggingInterceptor extends Interceptor {
  final Logger _logger = Logger('ApiClient');

  static const _redacted = '***redacted***';

  static const _sensitiveHeaders = {'authorization', 'cookie', 'set-cookie'};

  static const _sensitiveKeys = {
    'password',
    'currentpassword',
    'passwordconfirmation',
    'newpassword',
    'jwt',
    'token',
    'accesstoken',
    'refreshtoken',
    'apikey',
    'api_key',
    'secret',
  };

  bool _isSensitive(String key) => _sensitiveKeys.contains(key.toLowerCase());

  Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) {
    return headers.map((key, value) {
      if (_sensitiveHeaders.contains(key.toLowerCase())) {
        return MapEntry(key, _redacted);
      }
      return MapEntry(key, value);
    });
  }

  /// Rebuilds [uri] with the values of any sensitive query parameters redacted.
  String _redactUri(Uri uri) {
    if (uri.queryParameters.isEmpty) return uri.toString();

    final sanitized = <String, String>{
      for (final entry in uri.queryParameters.entries)
        entry.key: _isSensitive(entry.key) ? _redacted : entry.value,
    };
    return uri.replace(queryParameters: sanitized).toString();
  }

  /// Deep-redacts sensitive keys in request/response bodies.
  Object? _redactData(Object? data) {
    if (data is Map) {
      return data.map(
        (key, value) => MapEntry(
          key,
          (key is String && _isSensitive(key))
              ? _redacted
              : _redactData(value),
        ),
      );
    }
    if (data is Iterable) {
      return data.map(_redactData).toList();
    }
    return data;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger
      ..info('REQUEST: ${options.method} ${_redactUri(options.uri)}')
      ..fine('Headers: ${_redactHeaders(options.headers)}');

    if (options.data != null) {
      _logger.fine('Body: ${_redactData(options.data)}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger
      ..info(
        'RESPONSE: ${response.statusCode} '
        '${_redactUri(response.requestOptions.uri)}',
      )
      ..fine('Response data: ${_redactData(response.data)}');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger
      ..severe('ERROR: ${err.message}')
      ..severe(
        'Request: ${err.requestOptions.method} '
        '${_redactUri(err.requestOptions.uri)}',
      );

    if (err.response != null) {
      _logger.severe(
        'Response: ${err.response?.statusCode} '
        '${_redactData(err.response?.data)}',
      );
    }

    super.onError(err, handler);
  }
}
