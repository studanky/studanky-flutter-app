import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_cluster_item.dart';
import 'package:studanky_flutter_app/features/springs/data/cached_spring_marker_repository.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_repository.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';

import '../../support/map_marker_test_support.dart';

void main() {
  group('cache retention', () {
    const first = SpringBounds(
      west: 14.1,
      east: 14.2,
      south: 50.1,
      north: 50.2,
    );
    const second = SpringBounds(
      west: 15.1,
      east: 15.2,
      south: 50.1,
      north: 50.2,
    );
    const third = SpringBounds(
      west: 16.1,
      east: 16.2,
      south: 50.1,
      north: 50.2,
    );

    test('evicts the least recently used tile at the capacity bound', () async {
      final source = FakeSpringRepository([]);
      var now = DateTime(2026, 9, 5, 12);
      final cache = CachedSpringMarkerRepository(
        source,
        clock: () => now,
        maxTileCount: 2,
      );

      await cache.load(first, languageTag: testLanguageTag);
      now = now.add(const Duration(seconds: 1));
      await cache.load(second, languageTag: testLanguageTag);
      now = now.add(const Duration(seconds: 1));
      expect(cache.covers(first, languageTag: testLanguageTag), isTrue);
      now = now.add(const Duration(seconds: 1));
      await cache.load(third, languageTag: testLanguageTag);

      expect(cache.covers(first, languageTag: testLanguageTag), isTrue);
      expect(cache.covers(second, languageTag: testLanguageTag), isFalse);
      expect(cache.covers(third, languageTag: testLanguageTag), isTrue);
    });

    test('purges stale tiles after the retention window', () async {
      final source = FakeSpringRepository([]);
      var now = DateTime(2026, 9, 5, 12);
      final cache = CachedSpringMarkerRepository(
        source,
        clock: () => now,
        maxAge: const Duration(minutes: 5),
        retentionAge: const Duration(minutes: 30),
      );

      await cache.load(first, languageTag: testLanguageTag);
      expect(cache.hasDataFor(first, languageTag: testLanguageTag), isTrue);

      now = now.add(const Duration(minutes: 31));

      expect(cache.hasDataFor(first, languageTag: testLanguageTag), isFalse);
    });
  });

  test('returning to a visited area does not re-fetch', () async {
    final repository = FakeSpringRepository([prague, pragueNear, zdar]);
    final container = containerWith(repository);
    final notifier = container.read(testMapMarkerProvider.notifier);

    await notifier.reportCameraForTest(pragueBounds, 18);
    await notifier.reportCameraForTest(wideBounds, 10);
    await notifier.reportCameraForTest(pragueBounds, 18);
    await notifier.reportCameraForTest(wideBounds, 10);
    await notifier.reportCameraForTest(pragueBounds, 18);

    expect(repository.fetchCount, 2);
  });

  test('re-fetches a tile once its time-to-live expires', () async {
    final repository = FakeSpringRepository([prague, pragueNear]);
    var now = DateTime(2026, 7, 21, 12);
    final container = containerWith(
      repository,
      repositoryOverride: CachedSpringMarkerRepository(
        repository,
        clock: () => now,
        maxAge: const Duration(minutes: 5),
      ),
    );
    final notifier = container.read(testMapMarkerProvider.notifier);

    await notifier.reportCameraForTest(pragueBounds, 18);
    now = now.add(const Duration(minutes: 2));
    await notifier.reportCameraForTest(pragueBounds, 18);
    expect(repository.fetchCount, 1);

    now = now.add(const Duration(minutes: 5));
    await notifier.reportCameraForTest(pragueBounds, 18);

    expect(repository.fetchCount, 2);
    expect(container.read(testMapMarkerProvider).visibleBoundsLoaded, isTrue);
    expect(
      container
          .read(testMapMarkerProvider)
          .items
          .whereType<SpringPoint>()
          .length,
      2,
    );
  });

  test('a spring moved between tiles is not duplicated', () async {
    final repository = FakeSpringRepository([prague, pragueNear, zdar]);
    var now = DateTime(2026, 7, 21, 12);
    final container = containerWith(
      repository,
      repositoryOverride: CachedSpringMarkerRepository(
        repository,
        clock: () => now,
      ),
    );
    final notifier = container.read(testMapMarkerProvider.notifier);

    await notifier.reportCameraForTest(wideBounds, 10);
    final moved = zdar.copyWith(position: const LatLng(50.082, 14.423));
    repository.springs = [prague, pragueNear, moved];
    now = now.add(const Duration(minutes: 10));
    await notifier.reportCameraForTest(pragueBounds, 18);

    final springs = container.read(testSpringMarkersProvider).springs;
    expect(springs.map((item) => item.documentId), ['a', 'b', 'c']);
    expect(
      springs.firstWhere((item) => item.documentId == 'c').position,
      moved.position,
    );
  });

  test('a camera change during a fetch is queued', () async {
    final gate = Completer<void>();
    final repository = FakeSpringRepository([
      prague,
      pragueNear,
      zdar,
    ], gate: gate.future);
    final container = containerWith(repository);
    final notifier = container.read(testMapMarkerProvider.notifier);

    final first = notifier.reportCameraForTest(pragueBounds, 18);
    final second = notifier.reportCameraForTest(wideBounds, 18);
    gate.complete();
    await Future.wait([first, second]);

    expect(repository.fetchCount, 2);
    expect(
      container
          .read(testMapMarkerProvider)
          .items
          .whereType<SpringPoint>()
          .length,
      3,
    );
  });

  test('refreshVisible bypasses fresh coverage', () async {
    final repository = FakeSpringRepository([prague]);
    final container = containerWith(repository);
    final notifier = container.read(testMapMarkerProvider.notifier);

    await notifier.reportCameraForTest(pragueBounds, 18);
    await notifier.reportCameraForTest(pragueBounds, 18);
    expect(repository.fetchCount, 1);

    await notifier.refreshForTest();
    expect(repository.fetchCount, 2);
  });

  test('an unchanged refresh preserves spring and item lists', () async {
    final container = containerWith(FakeSpringRepository([prague]));
    final notifier = container.read(testMapMarkerProvider.notifier);

    await notifier.reportCameraForTest(pragueBounds, 18);
    final springs = container.read(testSpringMarkersProvider).springs;
    final items = container.read(testMapMarkerProvider).items;
    await notifier.refreshForTest();

    expect(container.read(testSpringMarkersProvider).springs, springs);
    expect(container.read(testMapMarkerProvider).items, items);
  });

  test('refreshVisible is a no-op before the first camera', () async {
    final repository = FakeSpringRepository([prague]);
    final container = containerWith(repository);

    await container.read(testMapMarkerProvider.notifier).refreshForTest();

    expect(repository.fetchCount, 0);
  });

  test('locale switch settles a stale request before new camera', () async {
    final repository = LocaleControlledSpringRepository();
    final container = ProviderContainer(
      overrides: [springRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    container.listen(testMapMarkerProvider, (_, _) {});
    final notifier = container.read(testMapMarkerProvider.notifier);

    final initialLoad = notifier.reportCameraForTest(
      pragueBounds,
      18,
      tag: 'cs',
    );
    repository.requests['cs']!.complete(
      ApiResult.success([spring('czech', 50.080, 14.420)]),
    );
    await initialLoad;

    final czechRefresh = notifier.refreshForTest(tag: 'cs');
    notifier.onLanguageTagChanged('en-AU');
    repository.requests['cs']!.complete(
      ApiResult.success([spring('late-czech', 50.080, 14.420)]),
    );
    await czechRefresh;

    expect(container.read(testMapMarkerProvider).status.isLoading, isFalse);
    expect(container.read(testSpringMarkersProvider).status.isLoading, isFalse);
    expect(repository.requests, isNot(contains('en-AU')));

    final englishLoad = notifier.reportCameraForTest(
      pragueBounds,
      18,
      tag: 'en-AU',
    );
    repository.requests['en-AU']!.complete(
      ApiResult.success([spring('english', 50.080, 14.420)]),
    );
    await englishLoad;

    expect(
      container
          .read(testMapMarkerProvider)
          .items
          .whereType<SpringPoint>()
          .single
          .spring
          .documentId,
      'english',
    );
    expect(container.read(testMapMarkerProvider).visibleBoundsLoaded, isTrue);
  });
}
