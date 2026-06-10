/// All navigable routes in the app. Keep this in sync with the route tree in
/// `app_router.dart` — these are the only screens reachable by location.
///
/// The spring detail and report submission are intentionally absent: the detail
/// is a modal bottom sheet (not a routed page) and report submission is a future
/// phase. Add entries here only when a screen becomes a real route.
enum AppRoutes {
  map('/map'),
  scanner('/scanner');

  const AppRoutes(this.path);

  final String path;
}
