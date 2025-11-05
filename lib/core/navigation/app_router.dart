import 'package:go_router/go_router.dart';
import 'package:studanky_flutter_app/core/navigation/app_route.dart';
import 'package:studanky_flutter_app/core/navigation/bottom_navigation_scaffold.dart';
import 'package:studanky_flutter_app/features/map_page/map_page.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/qr_scan_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.map.path,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          BottomNavigationScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.map.path,
              name: AppRoutes.map.name,
              builder: (context, state) => const MapPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.scanner.path,
              name: AppRoutes.scanner.name,
              builder: (context, state) => const QrScanPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
