import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/connectivity/connectivity_status.dart';
import 'package:studanky_flutter_app/core/connectivity/platform_connectivity_service.dart';

export 'package:studanky_flutter_app/core/connectivity/connectivity_status.dart';

/// Tracks whether the app can actually reach its backend.
///
/// **Ground truth = the app's own requests.** A dedicated reachability probe or
/// a bare `connectivity_plus` interface check is fragile: the iOS Simulator
/// doesn't reliably report the host Mac toggling Wi-Fi, and even on a real
/// device an interface can be "up" while no traffic flows (captive portal, dead
/// AP, DNS failure). So the primary signal is fed in from the network layer via
/// `reportReachable` / `reportUnreachable` (see `ConnectivityInterceptor`),
/// which observe real request outcomes and are therefore immediate and
/// simulator-proof — the Apple-recommended "try, then react" pattern.
///
/// `connectivity_plus` is kept only as an **accelerator**: a hard `none`
/// interface flips us offline instantly (even with no request in flight), and
/// an interface coming back flips us optimistically online so an idle map
/// recovers without waiting for the user to pan.
class ConnectivityController extends Notifier<ConnectivityStatus> {
  @override
  ConnectivityStatus build() {
    final service = ref.watch(connectivityServiceProvider);
    final subscription = service.statusChanges.listen((next) => state = next);
    // connectivity_plus doesn't deliver interface changes to a backgrounded
    // Android app (O+) and its iOS stream can miss events, so re-check the
    // interface whenever the app returns to the foreground.
    final lifecycle = AppLifecycleListener(
      onResume: () => unawaited(service.recheckInterface()),
    );
    ref
      ..onDispose(subscription.cancel)
      ..onDispose(lifecycle.dispose);

    return service.currentStatus;
  }
}

/// The device's current [ConnectivityStatus]. Kept alive: connectivity is an
/// app-wide concern whose listener should outlive any single screen.
final connectivityStatusProvider =
    NotifierProvider<ConnectivityController, ConnectivityStatus>(
      ConnectivityController.new,
    );
