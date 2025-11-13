enum AppRoutes {
  map('/map'),
  scanner('/scanner'),
  detail('/detail'),
  report('/report');

  const AppRoutes(this.path);
  final String path;
}
