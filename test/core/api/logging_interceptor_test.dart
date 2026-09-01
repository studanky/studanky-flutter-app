import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/core/api/interceptors/logging_interceptor.dart';

void main() {
  late Level originalRootLevel;
  late List<LogRecord> records;
  late StreamSubscription<LogRecord> subscription;

  setUp(() {
    originalRootLevel = Logger.root.level;
    Logger.root.level = Level.ALL;
    records = [];
    subscription = Logger.root.onRecord
        .where((record) => record.loggerName == 'ApiClient')
        .listen(records.add);
  });

  tearDown(() async {
    await subscription.cancel();
    Logger.root.level = originalRootLevel;
  });

  test('debug payload logging deeply redacts secrets', () {
    final interceptor = LoggingInterceptor(logPayloads: true);
    final options = RequestOptions(
      path: 'https://example.test/springs?apikey=query-secret',
      method: 'POST',
      headers: {'Authorization': 'Bearer header-secret'},
      data: {
        'name': 'Visible spring',
        'account': {
          'password': 'body-secret',
          'items': [
            {'refreshToken': 'nested-secret'},
          ],
        },
      },
    );

    interceptor.onRequest(options, RequestInterceptorHandler());

    final output = records.map((record) => record.message).join('\n');
    expect(output, contains('REQUEST: POST'));
    expect(output, contains('Visible spring'));
    expect(output, contains('redacted'));
    expect(output, isNot(contains('query-secret')));
    expect(output, isNot(contains('header-secret')));
    expect(output, isNot(contains('body-secret')));
    expect(output, isNot(contains('nested-secret')));
  });

  test('disabled payload logging never evaluates response data', () {
    final data = _ObservedIterable();
    final options = RequestOptions(path: 'https://example.test/springs');
    final response = Response<Object?>(
      requestOptions: options,
      statusCode: 200,
      data: data,
    );

    LoggingInterceptor(
      logPayloads: false,
    ).onResponse(response, ResponseInterceptorHandler());

    expect(data.iteratorRequests, 0);
    expect(data.stringifications, 0);
    expect(records.map((record) => record.level), [Level.INFO]);
    expect(records.single.message, contains('RESPONSE: 200'));
  });

  test('non-debug errors log safe metadata without response payload', () async {
    final options = RequestOptions(
      path: 'https://example.test/springs?token=query-secret',
      method: 'GET',
    );
    final error = DioException.badResponse(
      statusCode: 503,
      requestOptions: options,
      response: Response<Object?>(
        requestOptions: options,
        statusCode: 503,
        data: {'password': 'response-secret'},
      ),
    );
    final handler = _ObservedErrorInterceptorHandler();
    final handled = handler.handled;

    LoggingInterceptor(logPayloads: false).onError(error, handler);
    await handled;

    final output = records.map((record) => record.message).join('\n');
    expect(records.map((record) => record.level), [Level.SEVERE]);
    expect(output, contains('ERROR: badResponse GET'));
    expect(output, contains('status=503'));
    expect(output, contains('redacted'));
    expect(output, isNot(contains('query-secret')));
    expect(output, isNot(contains('response-secret')));
  });
}

class _ObservedIterable extends Iterable<Object?> {
  int iteratorRequests = 0;
  int stringifications = 0;

  @override
  Iterator<Object?> get iterator {
    iteratorRequests++;
    return const <Object?>['must not be read'].iterator;
  }

  @override
  String toString() {
    stringifications++;
    return super.toString();
  }
}

class _ObservedErrorInterceptorHandler extends ErrorInterceptorHandler {
  Future<void> get handled async {
    try {
      await future;
    } on Object {
      // ErrorInterceptorHandler deliberately completes its future with the
      // forwarded Dio error. The test only needs to observe that completion.
    }
  }
}
