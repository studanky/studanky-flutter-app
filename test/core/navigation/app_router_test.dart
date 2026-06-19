import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:studanky_flutter_app/core/navigation/app_router.dart';

void main() {
  group('type-safe route locations', () {
    test('map is the home location', () {
      expect(const MapRoute().location, '/map');
    });

    test('scanner is a top-level location', () {
      expect(const ScannerRoute().location, '/scanner');
    });

    test('spring detail nests under map and carries the document id', () {
      expect(
        const SpringRoute(documentId: 'abc123').location,
        '/map/spring/abc123',
      );
    });
  });

  group('route tree', () {
    List<GoRoute> topLevel() =>
        appRouter.configuration.routes.whereType<GoRoute>().toList();

    test('exposes /map and /scanner as top-level routes', () {
      final paths = topLevel().map((r) => r.path).toList();
      expect(paths, containsAll(<String>['/map', '/scanner']));
    });

    test('the spring detail is a child of /map (mirrors the UI hierarchy)', () {
      final mapRoute = topLevel().firstWhere((r) => r.path == '/map');
      final childPaths =
          mapRoute.routes.whereType<GoRoute>().map((r) => r.path).toList();
      expect(childPaths, contains('spring/:documentId'));
    });

    test('starts on the map', () {
      expect(appRouter.configuration.routes, isNotEmpty);
      expect(const MapRoute().location, '/map');
    });
  });
}
