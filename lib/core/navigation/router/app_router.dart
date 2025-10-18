import 'package:go_router/go_router.dart';
import 'package:studanky_flutter_app/core/navigation/app_routes/app_route.dart';
import 'package:studanky_flutter_app/features/main_page/main_page.dart';
import 'package:studanky_flutter_app/features/map/map_page.dart';
import 'package:studanky_flutter_app/features/qr_scan/qr_scan_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.scan.path,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainPage(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.scan.path,
              name: AppRoutes.scan.name,
              builder: (context, state) => const QrScanPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.map.path,
              name: AppRoutes.map.name,
              builder: (context, state) => const MapPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
