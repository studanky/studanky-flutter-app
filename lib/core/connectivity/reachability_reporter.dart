/// Narrow port through which HTTP outcomes update backend reachability.
abstract interface class ReachabilityReporter {
  void reportReachable();

  void reportUnreachable();
}
