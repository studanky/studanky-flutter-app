import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/providers/connectivity_status_provider.dart';

/// Feeds the app's real request outcomes into [connectivityStatusProvider], so
/// the offline banner reflects whether the backend is actually reachable rather
/// than a fragile interface check.
///
/// Placed **after** the retry interceptor so it only reacts to the final,
/// post-retry outcome, not to transient errors that a retry recovers.
class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor(this._ref);

  final Ref _ref;

  ConnectivityController get _controller =>
      _ref.read(connectivityStatusProvider.notifier);

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    // A response — even an HTTP error status — proves we reached the server.
    _controller.reportReachable();
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (classify(err)) {
      case RequestReachability.reachable:
        _controller.reportReachable();
      case RequestReachability.unreachable:
        _controller.reportUnreachable();
      case RequestReachability.inconclusive:
        // No evidence either way — a slow/hung backend (send/receive timeout),
        // a cancelled request or a TLS error doesn't prove the network is down,
        // so leave the connectivity state untouched.
        break;
    }
    super.onError(err, handler);
  }

  /// Classifies whether [err] is evidence the server was reachable, was
  /// unreachable, or is simply inconclusive.
  ///
  /// A response at all ⇒ reachable; a failure to establish the connection (or a
  /// raw socket/DNS error) ⇒ unreachable; everything else proves nothing.
  static RequestReachability classify(DioException err) {
    if (err.response != null) return RequestReachability.reachable;
    switch (err.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
        return RequestReachability.unreachable;
      case DioExceptionType.unknown:
        // Dio wraps a raw DNS/socket failure here (e.g. "Failed host lookup").
        return err.error is SocketException
            ? RequestReachability.unreachable
            : RequestReachability.inconclusive;
      default:
        // sendTimeout / receiveTimeout / cancel / badCertificate / … could be
        // a slow or misbehaving server, not a dead network.
        return RequestReachability.inconclusive;
    }
  }
}

/// What a request outcome tells us about server reachability.
enum RequestReachability { reachable, unreachable, inconclusive }
