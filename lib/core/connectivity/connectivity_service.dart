import 'package:studanky_flutter_app/core/connectivity/connectivity_status.dart';
import 'package:studanky_flutter_app/core/connectivity/reachability_reporter.dart';

/// Platform/data boundary for connectivity observations.
abstract interface class ConnectivityService implements ReachabilityReporter {
  ConnectivityStatus get currentStatus;

  Stream<ConnectivityStatus> get statusChanges;

  Future<void> recheckInterface();
}
