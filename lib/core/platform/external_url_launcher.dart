/// Platform boundary for opening a URL outside the application.
abstract interface class ExternalUrlLauncher {
  Future<bool> open(Uri uri);
}
