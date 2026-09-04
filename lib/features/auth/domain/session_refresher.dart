/// Narrow dependency used by the network layer after an unauthorized response.
abstract interface class SessionRefresher {
  Future<void> reAuthenticate();
}
