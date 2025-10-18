import 'package:go_router/go_router.dart';
import 'package:studanky_flutter_app/features/main_page/main_screen_page.dart';
import 'package:studanky_flutter_app/features/map/map_screen_page.dart';
import 'package:studanky_flutter_app/features/qr_scan/qr_scan_screen_page.dart';

enum AppRoute {
  scan('/scan'),
  map('/map');

  const AppRoute(this.path);
  final String path;
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoute.scan.path,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainScreenPage(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.scan.path,
              name: AppRoute.scan.name,
              builder: (context, state) => const QrScanScreenPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.map.path,
              name: AppRoute.map.name,
              builder: (context, state) => const MapScreenPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
