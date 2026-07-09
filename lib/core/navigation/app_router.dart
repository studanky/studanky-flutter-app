import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studanky_flutter_app/core/navigation/deep_links.dart';
import 'package:studanky_flutter_app/core/widgets/error_widget.dart';
import 'package:studanky_flutter_app/features/map_page/map_page.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/qr_scan_page.dart';
import 'package:studanky_flutter_app/features/spring_detail/spring_detail_page.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

part 'app_router.g.dart';

/// Root navigator key — declared top-level (never inside a `build`) with a
/// unique debug label, per go_router conventions. The single owner of the app's
/// navigation stack.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// The single source of truth for app navigation.
///
/// The map is the home. The spring detail overlays the map as a non-opaque,
/// deep-linkable child route (`/map/spring/:documentId`); the QR scanner is a
/// top-level route that, on a successful scan, navigates to that detail.
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: const MapRoute().location,
  routes: $appRoutes,
  // Graceful fallback for unknown locations (e.g. a stale deep link): show an
  // error screen that returns the user to the map.
  errorBuilder: (context, state) => Scaffold(
    body: SafeArea(
      child: AppErrorWidget(
        error: state.error ?? Exception('Unknown route: ${state.uri}'),
        stackTrace: StackTrace.empty,
        onRefresh: () => const MapRoute().go(context),
      ),
    ),
  ),
);

/// `/map` — the home screen.
@TypedGoRoute<MapRoute>(
  path: '/map',
  routes: [TypedGoRoute<SpringRoute>(path: 'spring/:documentId')],
)
class MapRoute extends GoRouteData with $MapRoute {
  const MapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const MapPage();
}

/// `/map/spring/:documentId` — spring detail, a non-opaque overlay above the
/// map.
///
/// [documentId] is a path param so the detail is deep-linkable (e.g. a QR code
/// at the spring). The optional [$extra] carries an already-loaded marker for an
/// instant header; when absent (deep link / scan) the page falls back to
/// fetching the spring by id.
class SpringRoute extends GoRouteData with $SpringRoute {
  const SpringRoute({required this.documentId, this.$extra});

  final String documentId;
  final SpringMarkerEntity? $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      SpringDetailPage.page(
        documentId: documentId,
        marker: $extra,
        state: state,
      );
}

/// `/s/:documentId` — public share entry point and Universal/App Link target.
///
/// The shared URL is deliberately short and brand-friendly
/// (`https://studankyapp.cz/s/{documentId}`, path-scoped so the marketing site
/// stays untouched). This route maps that public link onto the canonical
/// [SpringRoute], letting the two evolve independently. It is redirect-only and
/// never builds a screen. The path pattern is owned by [DeepLinks] so the route
/// matcher and the share-URL builder ([DeepLinks.springShareUrl]) share one
/// definition.
@TypedGoRoute<ShareRoute>(path: DeepLinks.springSharePattern)
class ShareRoute extends GoRouteData with $ShareRoute {
  const ShareRoute({required this.documentId});

  final String documentId;

  @override
  String? redirect(BuildContext context, GoRouterState state) =>
      SpringRoute(documentId: documentId).location;
}

/// `/scanner` — full-screen QR scanner.
@TypedGoRoute<ScannerRoute>(path: '/scanner')
class ScannerRoute extends GoRouteData with $ScannerRoute {
  const ScannerRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const QrScanPage();
}
