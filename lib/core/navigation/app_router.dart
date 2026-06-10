import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studanky_flutter_app/core/navigation/app_route.dart';
import 'package:studanky_flutter_app/core/widgets/error_widget.dart';
import 'package:studanky_flutter_app/features/map_page/map_page.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/qr_scan_page.dart';

/// The single source of truth for app navigation.
///
/// The MVP is effectively single-screen: the map is the home. The QR scan
/// screen has a route and is ready, but is intentionally **not wired into any
/// UI** yet — it will be linked from the map/detail in a later phase, so for now
/// it is reachable only by an explicit navigation to its path.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.map.path,
  routes: [
    GoRoute(
      path: AppRoutes.map.path,
      name: AppRoutes.map.name,
      builder: (context, state) => const MapPage(),
    ),
    GoRoute(
      path: AppRoutes.scanner.path,
      name: AppRoutes.scanner.name,
      builder: (context, state) => const QrScanPage(),
    ),
  ],
  // Graceful fallback for unknown locations (e.g. a stale deep link): show an
  // error screen that returns the user to the map.
  errorBuilder: (context, state) => Scaffold(
    body: SafeArea(
      child: AppErrorWidget(
        error: state.error ?? Exception('Unknown route: ${state.uri}'),
        stackTrace: StackTrace.empty,
        onRefresh: () => context.go(AppRoutes.map.path),
      ),
    ),
  ),
);
