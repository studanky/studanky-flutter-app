// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$mapRoute, $shareRoute, $scannerRoute];

RouteBase get $mapRoute => GoRouteData.$route(
  path: '/map',
  factory: $MapRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'spring/:documentId',
      factory: $SpringRoute._fromState,
    ),
  ],
);

mixin $MapRoute on GoRouteData {
  static MapRoute _fromState(GoRouterState state) => const MapRoute();

  @override
  String get location => GoRouteData.$location('/map');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SpringRoute on GoRouteData {
  static SpringRoute _fromState(GoRouterState state) => SpringRoute(
    documentId: state.pathParameters['documentId']!,
    $extra: state.extra as SpringMarkerEntity?,
  );

  SpringRoute get _self => this as SpringRoute;

  @override
  String get location => GoRouteData.$location(
    '/map/spring/${Uri.encodeComponent(_self.documentId)}',
  );

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $shareRoute =>
    GoRouteData.$route(path: '/s/:documentId', factory: $ShareRoute._fromState);

mixin $ShareRoute on GoRouteData {
  static ShareRoute _fromState(GoRouterState state) =>
      ShareRoute(documentId: state.pathParameters['documentId']!);

  ShareRoute get _self => this as ShareRoute;

  @override
  String get location =>
      GoRouteData.$location('/s/${Uri.encodeComponent(_self.documentId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $scannerRoute =>
    GoRouteData.$route(path: '/scanner', factory: $ScannerRoute._fromState);

mixin $ScannerRoute on GoRouteData {
  static ScannerRoute _fromState(GoRouterState state) => const ScannerRoute();

  @override
  String get location => GoRouteData.$location('/scanner');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
