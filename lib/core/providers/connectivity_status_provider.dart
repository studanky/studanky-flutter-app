import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Emits `true` when the device has an active internet connection.
final connectivityStatusProvider = StreamProvider.autoDispose<bool>((
  ref,
) async* {
  final connectivity = Connectivity();
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 3),
      receiveTimeout: const Duration(seconds: 3),
      sendTimeout: const Duration(seconds: 3),
    ),
  );

  ref.onDispose(() => dio.close(force: true));

  bool hasNetworkInterface(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((status) => status != ConnectivityResult.none);
  }

  Future<bool> hasInternetAccess() async {
    try {
      final response = await dio.get(
        'https://connectivitycheck.gstatic.com/generate_204',
        options: Options(
          followRedirects: false,
          responseType: ResponseType.plain,
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (response.statusCode == 204) return true;
      if (response.statusCode == 200) return true;
    } on DioException {
      // Any network error means we can't confirm reachability, so report offline.
    }

    return false;
  }

  Future<bool> evaluate(List<ConnectivityResult> results) async {
    if (!hasNetworkInterface(results)) return false;
    return hasInternetAccess();
  }

  final initialResults = await connectivity.checkConnectivity();
  yield await evaluate(initialResults);

  yield* connectivity.onConnectivityChanged.asyncMap(evaluate).distinct();
});
