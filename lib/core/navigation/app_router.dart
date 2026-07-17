import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studanky_flutter_app/core/navigation/deep_links.dart';
import 'package:studanky_flutter_app/core/widgets/error_widget.dart';
import 'package:studanky_flutter_app/features/map_page/map_page.dart';
// QR scanner disabled for the MVP (no camera permission shipped). Re-add this
// import together with the ScannerRoute below when re-enabling QR scanning.
// import 'package:studanky_flutter_app/features/qr_scan_page/qr_scan_page.dart';
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
/// The map is the home. The spring detail is deep-linkable
/// (`/map/spring/:documentId`) but is **not** a separate screen: both routes
/// resolve to the same [MapPage] page (same page key), so navigating between
/// them swaps a parameter on the live map instead of pushing a modal route.
/// The map keeps its camera and stays fully interactive under the half-open
/// detail sheet — the Google/Apple Maps pattern — and tapping another marker
/// switches the detail in one tap. The QR scanner is a top-level route that,
/// on a successful scan, navigates to the detail.
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

/// Shared page identity for `/map` and `/map/spring/:id`: pages with the same
/// key and type are *updated in place* by the Navigator, so switching between
/// the two routes rebuilds the one live map page (state preserved) instead of
/// pushing/popping. The detail sheet animates itself, so no page transition is
/// wanted here.
const ValueKey<String> _mapPageKey = ValueKey('map-page');

Page<void> _mapPage({String? detailDocumentId, SpringMarkerEntity? marker}) =>
    NoTransitionPage<void>(
      key: _mapPageKey,
      child: MapPage(
        detailDocumentId: detailDocumentId,
        detailMarker: marker,
      ),
    );

/// `/map` — the home screen.
@TypedGoRoute<MapRoute>(path: '/map')
class MapRoute extends GoRouteData with $MapRoute {
  const MapRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => _mapPage();
}

/// `/map/spring/:documentId` — the map with a spring's detail sheet open.
///
/// Declared as a *sibling* of [MapRoute] (not a child) on purpose: a child
/// route would add a second page to the stack, turning the detail back into a
/// modal overlay that blocks the map. As a sibling resolving to the same page
/// key, opening/closing/switching the detail is just a parameter change on the
/// live map page.
///
/// [documentId] is a path param so the detail is deep-linkable (e.g. a QR code
/// at the spring). The optional [$extra] carries an already-loaded marker for
/// an instant header; when absent (deep link / scan) the sheet falls back to
/// fetching the spring by id.
@TypedGoRoute<SpringRoute>(path: '/map/spring/:documentId')
class SpringRoute extends GoRouteData with $SpringRoute {
  const SpringRoute({required this.documentId, this.$extra});

  final String documentId;
  final SpringMarkerEntity? $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _mapPage(detailDocumentId: documentId, marker: $extra);
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

// `/scanner` — full-screen QR scanner.
//
// Disabled for the MVP: this release ships without the camera permission, so
// the scanner route is unregistered to keep any camera code path unreachable
// (opening it without the permission would crash on iOS). The feature code
// under features/qr_scan_page/ is kept intact. To re-enable: restore the
// NSCameraUsageDescription (iOS) and drop the CAMERA tools:node="remove"
// override (Android), uncomment the QrScanPage import above, and uncomment the
// route below, then re-run build_runner.
//
// @TypedGoRoute<ScannerRoute>(path: '/scanner')
// class ScannerRoute extends GoRouteData with $ScannerRoute {
//   const ScannerRoute();
//
//   @override
//   Widget build(BuildContext context, GoRouterState state) =>
//       const QrScanPage();
// }
