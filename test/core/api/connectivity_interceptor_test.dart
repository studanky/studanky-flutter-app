import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/core/api/interceptors/connectivity_interceptor.dart';

/// Covers the reachability classification rule: a response at all means the
/// server was reached (online), only a genuine failure to connect means
/// offline, and ambiguous failures (slow backend, cancellation, TLS) prove
/// nothing and must not move the connectivity state.
void main() {
  final options = RequestOptions(path: '/springs/map');

  DioException error({
    required DioExceptionType type,
    Response<dynamic>? response,
    Object? underlying,
  }) => DioException(
    requestOptions: options,
    type: type,
    response: response,
    error: underlying,
  );

  group('ConnectivityInterceptor.classify', () {
    test('any response — even an HTTP error — is reachable', () {
      final response = Response<dynamic>(requestOptions: options, statusCode: 500);
      expect(
        ConnectivityInterceptor.classify(
          error(type: DioExceptionType.badResponse, response: response),
        ),
        RequestReachability.reachable,
      );
    });

    test('connection error is unreachable', () {
      expect(
        ConnectivityInterceptor.classify(
          error(type: DioExceptionType.connectionError),
        ),
        RequestReachability.unreachable,
      );
    });

    test('connection timeout is unreachable', () {
      expect(
        ConnectivityInterceptor.classify(
          error(type: DioExceptionType.connectionTimeout),
        ),
        RequestReachability.unreachable,
      );
    });

    test('a raw DNS/socket failure (type unknown) is unreachable', () {
      expect(
        ConnectivityInterceptor.classify(
          error(
            type: DioExceptionType.unknown,
            underlying: const SocketException('Failed host lookup'),
          ),
        ),
        RequestReachability.unreachable,
      );
    });

    test('receive timeout is inconclusive (could be a slow backend)', () {
      expect(
        ConnectivityInterceptor.classify(
          error(type: DioExceptionType.receiveTimeout),
        ),
        RequestReachability.inconclusive,
      );
    });

    test('send timeout is inconclusive', () {
      expect(
        ConnectivityInterceptor.classify(
          error(type: DioExceptionType.sendTimeout),
        ),
        RequestReachability.inconclusive,
      );
    });

    test('a cancelled request proves nothing', () {
      expect(
        ConnectivityInterceptor.classify(error(type: DioExceptionType.cancel)),
        RequestReachability.inconclusive,
      );
    });

    test('a bad certificate reached the server but is inconclusive here', () {
      expect(
        ConnectivityInterceptor.classify(
          error(type: DioExceptionType.badCertificate),
        ),
        RequestReachability.inconclusive,
      );
    });

    test('an unknown error without a socket cause is inconclusive', () {
      expect(
        ConnectivityInterceptor.classify(
          error(type: DioExceptionType.unknown, underlying: StateError('x')),
        ),
        RequestReachability.inconclusive,
      );
    });
  });
}
