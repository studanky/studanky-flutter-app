import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

/// App-wide connectivity signal. Advisory and **optimistic**: the app assumes
/// [online] and only flips to [offline] once it has real evidence of it.
///
/// Modelled as an enum rather than a bare `bool` so future states (e.g.
/// `metered`) can be added without churning call sites.
enum ConnectivityStatus {
  online,
  offline;

  bool get isOffline => this == ConnectivityStatus.offline;
  bool get isOnline => this == ConnectivityStatus.online;
}

/// Tracks whether the app can actually reach its backend.
///
/// **Ground truth = the app's own requests.** A dedicated reachability probe or
/// a bare `connectivity_plus` interface check is fragile: the iOS Simulator
/// doesn't reliably report the host Mac toggling Wi-Fi, and even on a real
/// device an interface can be "up" while no traffic flows (captive portal, dead
/// AP, DNS failure). So the primary signal is fed in from the network layer via
/// [reportReachable] / [reportUnreachable] (see `ConnectivityInterceptor`),
/// which observe real request outcomes and are therefore immediate and
/// simulator-proof — the Apple-recommended "try, then react" pattern.
///
/// `connectivity_plus` is kept only as an **accelerator**: a hard `none`
/// interface flips us offline instantly (even with no request in flight), and
/// an interface coming back flips us optimistically online so an idle map
/// recovers without waiting for the user to pan.
class ConnectivityController extends Notifier<ConnectivityStatus> {
  final Logger _logger = Logger('Connectivity');
  final Connectivity _connectivity = Connectivity();

  @override
  ConnectivityStatus build() {
    final subscription = _connectivity.onConnectivityChanged.listen(
      _onInterfaceChanged,
    );
    // connectivity_plus doesn't deliver interface changes to a backgrounded
    // Android app (O+) and its iOS stream can miss events, so re-check the
    // interface whenever the app returns to the foreground.
    final lifecycle = AppLifecycleListener(
      onResume: () => unawaited(recheckInterface()),
    );
    ref
      ..onDispose(subscription.cancel)
      ..onDispose(lifecycle.dispose);

    // Cold-start hard check: if the device starts with no interface at all,
    // reflect that immediately. Otherwise stay optimistically online and let
    // the first real request confirm or correct it.
    unawaited(recheckInterface());

    return ConnectivityStatus.online;
  }

  /// Re-reads the network interface and flips to `offline` when there is none.
  /// Deliberately does **not** assume `online` when an interface is present — a
  /// live interface doesn't prove real connectivity, so recovery is left to the
  /// next real request (see `ConnectivityInterceptor`). Called on cold start and
  /// on app resume.
  Future<void> recheckInterface() async {
    final results = await _connectivity.checkConnectivity();
    if (!_hasInterface(results)) {
      _set(ConnectivityStatus.offline, reason: 'no network interface');
    }
  }

  bool _hasInterface(List<ConnectivityResult> results) =>
      results.any((result) => result != ConnectivityResult.none);

  void _onInterfaceChanged(List<ConnectivityResult> results) {
    if (_hasInterface(results)) {
      // Interface returned — assume online. A captive portal / dead AP is
      // corrected by the next failing request calling [reportUnreachable].
      _set(ConnectivityStatus.online, reason: 'interface up');
    } else {
      _set(ConnectivityStatus.offline, reason: 'interface none');
    }
  }

  /// Called by the network layer when a request reached the server (any
  /// response, including HTTP errors — we still touched the network).
  void reportReachable() =>
      _set(ConnectivityStatus.online, reason: 'request reached server');

  /// Called by the network layer when a request could not reach the server
  /// (connection error / timeout / DNS failure).
  void reportUnreachable() =>
      _set(ConnectivityStatus.offline, reason: 'request could not reach server');

  void _set(ConnectivityStatus next, {required String reason}) {
    if (state == next) return;
    _logger.info('${state.name} → ${next.name} ($reason)');
    state = next;
  }
}

/// The device's current [ConnectivityStatus]. Kept alive: connectivity is an
/// app-wide concern whose listener should outlive any single screen.
final connectivityStatusProvider =
    NotifierProvider<ConnectivityController, ConnectivityStatus>(
      ConnectivityController.new,
    );
