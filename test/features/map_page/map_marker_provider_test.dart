import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_cluster_item.dart';
import 'package:studanky_flutter_app/features/map_page/providers/map_marker_provider.dart'
    as map_marker_providers;
import 'package:studanky_flutter_app/features/springs/data/cached_spring_marker_repository.dart'
    as marker_repositories;
import 'package:studanky_flutter_app/features/springs/data/cached_spring_marker_repository.dart'
    show CachedSpringMarkerRepository, SpringMarkerRepository;
import 'package:studanky_flutter_app/features/springs/data/spring_repository.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_search_result.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';
import 'package:studanky_flutter_app/features/springs/providers/spring_markers_provider.dart'
    as spring_marker_providers;

const _languageTag = 'cs';
final mapMarkerProvider = map_marker_providers.mapMarkerProvider;
final springMarkersProvider = spring_marker_providers.springMarkersProvider;
final springMarkerRepositoryProvider =
    marker_repositories.springMarkerRepositoryProvider;

extension _MapMarkerNotifierTestApi on map_marker_providers.MapMarkerNotifier {
  Future<void> reportCamera(LatLngBounds bounds, double zoom, {String? tag}) =>
      onCameraChanged(bounds, zoom, languageTag: tag ?? _languageTag);

  Future<void> refreshForTest({String? tag}) =>
      refreshVisible(languageTag: tag ?? _languageTag);
}

SpringMarkerEntity _spring(String id, double lat, double lng) =>
    SpringMarkerEntity(
      documentId: id,
      name: id,
      position: LatLng(lat, lng),
      status: SpringStatus.unknown,
    );

// Two springs ~150 m apart near Prague, one far away in Žďár. With the default
// 0.5° grid the Prague pair shares one tile and Žďár sits in another.
final _prague = _spring('a', 50.080, 14.420);
final _pragueNear = _spring('b', 50.081, 14.421);
final _zdar = _spring('c', 49.563, 15.940);
final _praguePaddingRing = _spring('padding', 49.98, 14.42);

// A box covering all three.
final _wideBounds = LatLngBounds(
  const LatLng(50.2, 16.0),
  const LatLng(49.4, 14.0),
);

// A tight box around Prague only (excludes Žďár).
final _pragueBounds = LatLngBounds(
  const LatLng(50.15, 14.6),
  const LatLng(50.00, 14.30),
);

/// Prague, nudged well inside the padded clustering window (the box grows by
/// 20 %, i.e. 0.03° of latitude here).
final _pragueBoundsNudged = LatLngBounds(
  const LatLng(50.16, 14.61),
  const LatLng(50.01, 14.31),
);

/// Fake repository that returns the fixed springs falling inside the requested
/// bounds, mirroring what the real `GET /springs/map?bbox=` would serve.
class _FakeSpringRepository implements SpringRepository {
  _FakeSpringRepository(this.springs, {this.gate, this.gateOnFetch = 1});

  /// Mutable so a test can change what the backend serves between fetches.
  List<SpringMarkerEntity> springs;

  /// When set, request number [gateOnFetch] parks on this future — lets a test
  /// inspect state while a selected camera fetch is still open.
  final Future<void>? gate;
  final int gateOnFetch;
  bool _gatePassed = false;

  /// Number of times the map-markers endpoint was hit — lets a test assert the
  /// coverage short-circuit (and its forced bypass) actually control fetching.
  int fetchCount = 0;
  final List<String> requestedLanguageTags = [];

  @override
  Future<ApiResult<List<SpringMarkerEntity>>> fetchMapMarkers({
    required SpringBounds bounds,
    required String languageTag,
  }) async {
    fetchCount++;
    requestedLanguageTags.add(languageTag);
    if (gate != null && !_gatePassed && fetchCount == gateOnFetch) {
      _gatePassed = true;
      await gate;
    }
    final inBounds = springs
        .where(
          (spring) => bounds.containsPosition(
            latitude: spring.position.latitude,
            longitude: spring.position.longitude,
          ),
        )
        .toList(growable: false);
    return ApiResult.success(inBounds);
  }

  @override
  Future<ApiResult<List<SpringSearchResult>>> searchByName({
    required String query,
    required String languageTag,
    LatLng? origin,
    int limit = 5,
  }) async {
    return const ApiResult.success([]);
  }
}

class _LocaleControlledRepository implements SpringRepository {
  final Map<String, Completer<ApiResult<List<SpringMarkerEntity>>>> requests =
      {};

  @override
  Future<ApiResult<List<SpringMarkerEntity>>> fetchMapMarkers({
    required SpringBounds bounds,
    required String languageTag,
  }) {
    final completer = Completer<ApiResult<List<SpringMarkerEntity>>>();
    requests[languageTag] = completer;
    return completer.future;
  }

  @override
  Future<ApiResult<List<SpringSearchResult>>> searchByName({
    required String query,
    required String languageTag,
    LatLng? origin,
    int limit = 5,
  }) async => const ApiResult.success([]);
}

ProviderContainer _containerWith(
  _FakeSpringRepository repository, {
  SpringMarkerRepository? repositoryOverride,
}) {
  final container = ProviderContainer(
    overrides: [
      springRepositoryProvider.overrideWithValue(repository),
      if (repositoryOverride != null)
        springMarkerRepositoryProvider.overrideWithValue(repositoryOverride),
    ],
  );
  addTearDown(container.dispose);
  // The map page watches the provider; keep it alive here too so the
  // autoDispose notifier survives its own awaits.
  container.listen(mapMarkerProvider, (_, _) {}, fireImmediately: true);
  return container;
}

void main() {
  test('renders each spring individually at high zoom', () async {
    final container = _containerWith(
      _FakeSpringRepository([_prague, _pragueNear, _zdar]),
    );
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.reportCamera(_wideBounds, 18);

    final items = container.read(mapMarkerProvider).items;
    expect(items.whereType<SpringPoint>().length, 3);
    expect(items.whereType<Cluster>(), isEmpty);
  });

  test('groups nearby springs into fewer items at low zoom', () async {
    final container = _containerWith(
      _FakeSpringRepository([_prague, _pragueNear, _zdar]),
    );
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.reportCamera(_wideBounds, 5);

    final items = container.read(mapMarkerProvider).items;
    expect(items.length, lessThan(3));
    expect(items.whereType<Cluster>(), isNotEmpty);
  });

  test('clusters only the springs inside the camera window', () async {
    final container = _containerWith(
      _FakeSpringRepository([_prague, _pragueNear, _zdar]),
    );
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.reportCamera(_pragueBounds, 18);
    expect(
      container.read(mapMarkerProvider).items.whereType<SpringPoint>().length,
      2,
    );

    await notifier.reportCamera(_wideBounds, 18);
    expect(
      container.read(mapMarkerProvider).items.whereType<SpringPoint>().length,
      3,
    );
  });

  test('fetches and clusters a spring in the padded data window', () async {
    expect(
      _pragueBounds.contains(_praguePaddingRing.position),
      isFalse,
      reason: 'The fixture must stay outside the visible viewport.',
    );
    final container = _containerWith(
      _FakeSpringRepository([_praguePaddingRing]),
    );
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.reportCamera(_pragueBounds, 18);

    final paddedState = container.read(mapMarkerProvider);
    final points = paddedState.items.whereType<SpringPoint>();
    expect(points.single.spring, _praguePaddingRing);
    expect(paddedState.visibleBoundsLoaded, isTrue);
    expect(
      paddedState.hasVisibleMarkers,
      isFalse,
      reason: 'A prefetched marker must not hide the empty-viewport message.',
    );

    // Move just far enough for the prefetched marker to enter the viewport,
    // while staying inside the existing clustering window and fetched tiles.
    // The item list remains untouched, but its visibility projection changes.
    final pannedBounds = LatLngBounds(
      const LatLng(50.125, 14.60),
      const LatLng(49.975, 14.30),
    );
    final pannedLoad = notifier.reportCamera(pannedBounds, 18);
    final visibleState = container.read(mapMarkerProvider);
    expect(visibleState.hasVisibleMarkers, isTrue);
    expect(
      identical(visibleState.items.single, paddedState.items.single),
      isTrue,
    );
    await pannedLoad;
  });

  test(
    'keeps the visible bounds loaded while only the padding ring fetches',
    () async {
      final secondFetchGate = Completer<void>();
      addTearDown(() {
        if (!secondFetchGate.isCompleted) secondFetchGate.complete();
      });
      final visibleSpring = _spring('visible', 50.075, 14.447);
      final repository = _FakeSpringRepository(
        [visibleSpring],
        gate: secondFetchGate.future,
        gateOnFetch: 2,
      );
      final container = _containerWith(repository);
      final notifier = container.read(mapMarkerProvider.notifier);
      final initialBounds = LatLngBounds(
        const LatLng(50.10, 14.45),
        const LatLng(50.05, 14.40),
      );
      final pannedBounds = LatLngBounds(
        const LatLng(50.10, 14.492),
        const LatLng(50.05, 14.442),
      );

      // The first data window remains wholly inside tile x=28.
      await notifier.reportCamera(initialBounds, 18);
      expect(repository.fetchCount, 1);
      expect(container.read(mapMarkerProvider).visibleBoundsLoaded, isTrue);

      // The panned viewport is still inside cached tile x=28, but its padded
      // east edge crosses 14.5 degrees and starts fetching tile x=29.
      final paddingFetch = notifier.reportCamera(pannedBounds, 18);
      final fetchingState = container.read(mapMarkerProvider);

      expect(repository.fetchCount, 2);
      expect(fetchingState.status.isLoading, isTrue);
      expect(
        fetchingState.items.whereType<SpringPoint>().single.spring,
        visibleSpring,
      );
      expect(fetchingState.visibleBoundsLoaded, isTrue);
      expect(
        fetchingState.status.isLoading && !fetchingState.visibleBoundsLoaded,
        isFalse,
        reason: 'The map spinner must stay hidden over visible cached data.',
      );

      secondFetchGate.complete();
      await paddingFetch;
    },
  );

  test('returning to a visited area does not re-fetch', () async {
    final repository = _FakeSpringRepository([_prague, _pragueNear, _zdar]);
    final container = _containerWith(repository);
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.reportCamera(_pragueBounds, 18);
    expect(repository.fetchCount, 1);

    // Zooming out reaches tiles Prague never covered, so this one is real.
    await notifier.reportCamera(_wideBounds, 10);
    expect(repository.fetchCount, 2);

    // Everything from here on is inside tiles already fetched. A rectangle-based
    // cache would re-request on each of these — that was the flicker.
    await notifier.reportCamera(_pragueBounds, 18);
    await notifier.reportCamera(_wideBounds, 10);
    await notifier.reportCamera(_pragueBounds, 18);

    expect(repository.fetchCount, 2);
  });

  test('panning inside the cluster window emits no state at all', () async {
    final container = _containerWith(
      _FakeSpringRepository([_prague, _pragueNear, _zdar]),
    );
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.reportCamera(_pragueBounds, 18);
    final state = container.read(mapMarkerProvider);

    // The very same state object, meaning nothing was emitted: the map page
    // never rebuilds and the marker layer stays exactly as it is.
    await notifier.reportCamera(_pragueBoundsNudged, 18);
    expect(identical(container.read(mapMarkerProvider), state), isTrue);

    // Leaving the window recomputes.
    await notifier.reportCamera(_wideBounds, 18);
    expect(container.read(mapMarkerProvider).items, isNot(state.items));
  });

  test(
    'marks the visible bounds as loaded when no springs are returned',
    () async {
      final container = _containerWith(_FakeSpringRepository([]));
      final notifier = container.read(mapMarkerProvider.notifier);

      await notifier.reportCamera(_pragueBounds, 18);

      final state = container.read(mapMarkerProvider);
      expect(state.items, isEmpty);
      expect(state.visibleBoundsLoaded, isTrue);
    },
  );

  test('re-fetches a tile once its time-to-live expires', () async {
    final repository = _FakeSpringRepository([_prague, _pragueNear]);
    var now = DateTime(2026, 7, 21, 12);
    final container = _containerWith(
      repository,
      repositoryOverride: CachedSpringMarkerRepository(
        repository,
        clock: () => now,
        maxAge: const Duration(minutes: 5),
      ),
    );
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.reportCamera(_pragueBounds, 18);
    expect(repository.fetchCount, 1);

    // Still fresh two minutes on: a browsing session must not re-request.
    now = now.add(const Duration(minutes: 2));
    await notifier.reportCamera(_pragueBounds, 18);
    expect(repository.fetchCount, 1);

    // Past the TTL the same camera is refreshed, so a report submitted
    // meanwhile shows up.
    now = now.add(const Duration(minutes: 5));
    await notifier.reportCamera(_pragueBounds, 18);
    expect(repository.fetchCount, 2);

    // A stale tile still has data to draw, so the area never reads as unloaded
    // and the map keeps its markers while the refresh runs.
    expect(container.read(mapMarkerProvider).visibleBoundsLoaded, isTrue);
    expect(
      container.read(mapMarkerProvider).items.whereType<SpringPoint>().length,
      2,
    );
  });

  test(
    'a spring whose coordinates moved between tiles is not duplicated',
    () async {
      final repository = _FakeSpringRepository([_prague, _pragueNear, _zdar]);
      var now = DateTime(2026, 7, 21, 12);
      final container = _containerWith(
        repository,
        repositoryOverride: CachedSpringMarkerRepository(
          repository,
          clock: () => now,
        ),
      );
      final notifier = container.read(mapMarkerProvider.notifier);

      // Caches Prague's tile and Žďár's tile in one go — Prague's is created
      // first, so it is also walked first when reading the cache back.
      await notifier.reportCamera(_wideBounds, 10);
      expect(container.read(springMarkersProvider).springs.length, 3);

      // The backend corrects c's coordinates, far enough to land in Prague's tile.
      final moved = _zdar.copyWith(position: const LatLng(50.082, 14.423));
      repository.springs = [_prague, _pragueNear, moved];

      // Past the TTL a Prague camera refreshes only Prague's tile. Žďár's tile
      // keeps its stale copy of c — and is read *after* the refreshed one, so
      // taking "the last one seen" would resurrect the old position.
      now = now.add(const Duration(minutes: 10));
      await notifier.reportCamera(_pragueBounds, 18);

      final springs = container.read(springMarkersProvider).springs;
      expect(springs.map((spring) => spring.documentId), ['a', 'b', 'c']);
      expect(
        springs.firstWhere((spring) => spring.documentId == 'c').position,
        moved.position,
      );
    },
  );

  test('a camera change during a fetch is served, not swallowed', () async {
    final gate = Completer<void>();
    final repository = _FakeSpringRepository([
      _prague,
      _pragueNear,
      _zdar,
    ], gate: gate.future);
    final container = _containerWith(repository);
    final notifier = container.read(mapMarkerProvider.notifier);

    // Prague is still on the wire when the user zooms out to a wider area.
    final first = notifier.reportCamera(_pragueBounds, 18);
    final second = notifier.reportCamera(_wideBounds, 18);
    gate.complete();
    await Future.wait([first, second]);

    // Joining the in-flight request without queueing the new bounds would leave
    // Žďár unfetched — the trap the tile-grid strategy would otherwise fall into.
    expect(repository.fetchCount, 2);
    expect(
      container.read(mapMarkerProvider).items.whereType<SpringPoint>().length,
      3,
    );
  });

  test('refreshVisible forces a re-fetch past the coverage check', () async {
    final repository = _FakeSpringRepository([_prague]);
    final container = _containerWith(repository);
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.reportCamera(_pragueBounds, 18);
    expect(repository.fetchCount, 1);

    // Re-reporting the same (cached) camera must NOT hit the network.
    await notifier.reportCamera(_pragueBounds, 18);
    expect(repository.fetchCount, 1);

    // refreshVisible bypasses the cache and re-verifies via a real request —
    // the recovery path used on app resume while offline.
    await notifier.refreshForTest();
    expect(repository.fetchCount, 2);
  });

  test('an unchanged refresh leaves the springs and the markers alone', () async {
    final container = _containerWith(_FakeSpringRepository([_prague]));
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.reportCamera(_pragueBounds, 18);
    final springs = container.read(springMarkersProvider).springs;
    final items = container.read(mapMarkerProvider).items;

    // The resume probe re-fetches; unchanged data must not duplicate springs or
    // disturb what is drawn.
    await notifier.refreshForTest();

    expect(container.read(springMarkersProvider).springs, springs);
    expect(container.read(mapMarkerProvider).items, items);
  });

  test(
    'refreshVisible is a no-op before the first camera is reported',
    () async {
      final repository = _FakeSpringRepository([_prague]);
      final container = _containerWith(repository);
      final notifier = container.read(mapMarkerProvider.notifier);

      await notifier.refreshForTest();
      expect(repository.fetchCount, 0);
    },
  );

  test('locale switch resolves stale loading before a new camera is queued', () async {
    final repository = _LocaleControlledRepository();
    final container = ProviderContainer(
      overrides: [springRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    container.listen(mapMarkerProvider, (_, _) {});
    final notifier = container.read(mapMarkerProvider.notifier);

    final initialLoad = notifier.reportCamera(_pragueBounds, 18, tag: 'cs');
    repository.requests['cs']!.complete(
      ApiResult.success([_spring('czech', 50.080, 14.420)]),
    );
    await initialLoad;
    expect(
      container
          .read(mapMarkerProvider)
          .items
          .whereType<SpringPoint>()
          .single
          .spring
          .documentId,
      'czech',
    );

    // Start a Czech refresh, then switch locale while that request is still
    // running. Deliberately do not queue the English camera yet: this is the
    // production window between didChangeDependencies and its post-frame
    // callback that previously left status stuck at loading.
    final czechRefresh = notifier.refreshForTest(tag: 'cs');
    notifier.onLanguageTagChanged('en-AU');
    expect(
      container
          .read(mapMarkerProvider)
          .items
          .whereType<SpringPoint>()
          .single
          .spring
          .documentId,
      'czech',
    );
    expect(container.read(mapMarkerProvider).visibleBoundsLoaded, isFalse);

    repository.requests['cs']!.complete(
      ApiResult.success([_spring('late-czech', 50.080, 14.420)]),
    );
    await czechRefresh;

    // The late completion is cached as stale tile data, but cannot replace the
    // active visible state or strand the loading status. No request is queued
    // until the post-frame camera callback below actually arrives.
    expect(
      container
          .read(mapMarkerProvider)
          .items
          .whereType<SpringPoint>()
          .single
          .spring
          .documentId,
      'czech',
    );
    expect(container.read(mapMarkerProvider).status.isLoading, isFalse);
    expect(container.read(springMarkersProvider).status.isLoading, isFalse);
    expect(repository.requests, isNot(contains('en-AU')));

    final englishLoad = notifier.reportCamera(_pragueBounds, 18, tag: 'en-AU');
    repository.requests['en-AU']!.complete(
      ApiResult.success([_spring('english', 50.080, 14.420)]),
    );
    await englishLoad;

    expect(
      container
          .read(mapMarkerProvider)
          .items
          .whereType<SpringPoint>()
          .single
          .spring
          .documentId,
      'english',
    );
    expect(container.read(mapMarkerProvider).visibleBoundsLoaded, isTrue);
  });
}
