/// Platform boundary for application metadata.
abstract interface class AppInfoService {
  Future<String> loadVersion();
}
