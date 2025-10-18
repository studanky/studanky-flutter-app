enum AppRoutes {
  scan('/scan'),
  map('/map');

  const AppRoutes(this.path);
  final String path;
}
