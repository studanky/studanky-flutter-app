/// App-wide, optimistic backend reachability state.
enum ConnectivityStatus {
  online,
  offline;

  bool get isOffline => this == ConnectivityStatus.offline;
  bool get isOnline => this == ConnectivityStatus.online;
}
