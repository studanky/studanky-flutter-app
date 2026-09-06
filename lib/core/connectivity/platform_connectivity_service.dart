import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/connectivity/connectivity_service.dart';
import 'package:studanky_flutter_app/core/connectivity/connectivity_status.dart';

part 'platform_connectivity_service.g.dart';

/// Combines interface events with real backend request outcomes.
class PlatformConnectivityService implements ConnectivityService {
  PlatformConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      _onInterfaceChanged,
      onError: (Object error, StackTrace stackTrace) {
        _logger.warning(
          'Unable to observe network interface changes.',
          error,
          stackTrace,
        );
      },
    );
    unawaited(recheckInterface());
  }

  final Logger _logger = Logger('Connectivity');
  final Connectivity _connectivity;
  final StreamController<ConnectivityStatus> _statusChanges =
      StreamController<ConnectivityStatus>.broadcast();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityStatus _currentStatus = ConnectivityStatus.online;

  @override
  ConnectivityStatus get currentStatus => _currentStatus;

  @override
  Stream<ConnectivityStatus> get statusChanges => _statusChanges.stream;

  @override
  Future<void> recheckInterface() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (!_hasInterface(results)) {
        _set(ConnectivityStatus.offline, reason: 'no network interface');
      }
    } on Object catch (error, stackTrace) {
      // Connectivity is advisory; plugin failures must not block app startup.
      _logger.warning(
        'Unable to check the network interface.',
        error,
        stackTrace,
      );
    }
  }

  bool _hasInterface(List<ConnectivityResult> results) =>
      results.any((result) => result != ConnectivityResult.none);

  void _onInterfaceChanged(List<ConnectivityResult> results) {
    _set(
      _hasInterface(results)
          ? ConnectivityStatus.online
          : ConnectivityStatus.offline,
      reason: _hasInterface(results) ? 'interface up' : 'interface none',
    );
  }

  @override
  void reportReachable() =>
      _set(ConnectivityStatus.online, reason: 'request reached server');

  @override
  void reportUnreachable() => _set(
    ConnectivityStatus.offline,
    reason: 'request could not reach server',
  );

  void _set(ConnectivityStatus next, {required String reason}) {
    if (_currentStatus == next) return;
    _logger.info('${_currentStatus.name} → ${next.name} ($reason)');
    _currentStatus = next;
    _statusChanges.add(next);
  }

  Future<void> dispose() async {
    await _subscription.cancel();
    await _statusChanges.close();
  }
}

@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) {
  final service = PlatformConnectivityService();
  ref.onDispose(service.dispose);
  return service;
}
