import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Logs requests/responses through the `logging` package configured in
/// `main.dart`. Sensitive data is redacted before it ever reaches the logs:
/// secret headers (e.g. `Authorization`), secret query parameters (e.g. the
/// Mapy.com `apikey`) and secret body fields (passwords, tokens).
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({this.logPayloads = kDebugMode});

  final Logger _logger = Logger('ApiClient');
  final bool logPayloads;

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

  /// Builds the message only when its level is enabled. This is important for
  /// request/response bodies: deep redaction and collection stringification
  /// can be expensive even when the logging backend eventually drops a record.
  void _log(Level level, Object Function() message) {
    if (!_logger.isLoggable(level)) return;
    _logger.log(level, message());
  }

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
          (key is String && _isSensitive(key)) ? _redacted : _redactData(value),
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
    _log(
      Level.INFO,
      () => 'REQUEST: ${options.method} ${_redactUri(options.uri)}',
    );

    if (logPayloads) {
      _log(Level.FINE, () => 'Headers: ${_redactHeaders(options.headers)}');
      if (options.data != null) {
        _log(Level.FINE, () => 'Body: ${_redactData(options.data)}');
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log(
      Level.INFO,
      () =>
          'RESPONSE: ${response.statusCode} '
          '${_redactUri(response.requestOptions.uri)}',
    );
    if (logPayloads) {
      _log(Level.FINE, () => 'Response data: ${_redactData(response.data)}');
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log(
      Level.SEVERE,
      () =>
          'ERROR: ${err.type.name} ${err.requestOptions.method} '
          '${_redactUri(err.requestOptions.uri)} '
          'status=${err.response?.statusCode ?? '-'}',
    );

    if (logPayloads && err.response != null) {
      _log(
        Level.SEVERE,
        () =>
            'Response: ${err.response?.statusCode} '
            '${_redactData(err.response?.data)}',
      );
    }

    super.onError(err, handler);
  }
}
