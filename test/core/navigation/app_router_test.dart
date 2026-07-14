import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:studanky_flutter_app/core/navigation/app_router.dart';
import 'package:studanky_flutter_app/core/navigation/deep_links.dart';

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

    test('share link is the short public location', () {
      expect(const ShareRoute(documentId: 'abc123').location, '/s/abc123');
    });

    test('share route location matches DeepLinks.springSharePath (no drift)', () {
      // The @TypedGoRoute path references DeepLinks.springSharePattern, so the
      // generated matcher and the URL builder must resolve to the same path.
      expect(
        const ShareRoute(documentId: 'abc123').location,
        DeepLinks.springSharePath('abc123'),
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

    test('exposes the public share route at the top level', () {
      final paths = topLevel().map((r) => r.path).toList();
      // Assert against the constant the annotation is built from, so this tracks
      // DeepLinks.springSharePattern rather than a hardcoded literal.
      expect(paths, contains(DeepLinks.springSharePattern));
    });

    test('the share route carries a redirect, not a screen', () {
      final shareRoute = topLevel().firstWhere(
        (r) => r.path == DeepLinks.springSharePattern,
      );
      expect(shareRoute.redirect, isNotNull);
    });

    test('the spring detail is a top-level sibling of /map (one live page)', () {
      // Deliberately NOT a child of /map: a child route would add a second,
      // modal page above the map. As a sibling resolving to the same page key,
      // opening/closing/switching the detail is a parameter change on the live
      // map page — the map stays interactive behind the half-open sheet and
      // tapping another marker switches the detail in one tap.
      final paths = topLevel().map((r) => r.path).toList();
      expect(paths, contains('/map/spring/:documentId'));

      final mapRoute = topLevel().firstWhere((r) => r.path == '/map');
      expect(mapRoute.routes, isEmpty);
    });

    test('starts on the map', () {
      expect(appRouter.configuration.routes, isNotEmpty);
      expect(const MapRoute().location, '/map');
    });
  });

  group('share link redirect', () {
    testWidgets('/s/:documentId redirects to the spring detail for the same id', (
      tester,
    ) async {
      // Exercises ShareRoute.redirect against stub screens (no MapPage /
      // providers), so the test stays fast and isolated from the real pages.
      final router = GoRouter(
        initialLocation: const ShareRoute(documentId: 'abc123').location,
        routes: [
          GoRoute(
            path: '/map/spring/:documentId',
            builder: (_, _) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: '/s/:documentId',
            redirect: (context, state) => ShareRoute(
              documentId: state.pathParameters['documentId']!,
            ).redirect(context, state),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(
        router.state.matchedLocation,
        const SpringRoute(documentId: 'abc123').location,
      );
    });
  });
}
