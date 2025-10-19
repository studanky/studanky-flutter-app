import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Emits `true` when the device has an active internet connection.
final connectivityStatusProvider = StreamProvider.autoDispose<bool>((ref) {
  final connectivity = Connectivity();
  final controller = StreamController<bool>();

  Future<void>(() async {
    final initial = await connectivity.checkConnectivity();
    if (!controller.isClosed) {
      controller.add(initial != ConnectivityResult.none);
    }
  });

  final subscription = connectivity.onConnectivityChanged.listen((result) {
    if (!controller.isClosed) {
      controller.add(result != ConnectivityResult.none);
    }
  });

  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
});
