import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_cluster_item.dart';
import 'package:studanky_flutter_app/features/map_page/providers/map_marker_provider.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_marker_source.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_repository.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_search_result.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';
import 'package:studanky_flutter_app/features/springs/providers/spring_markers_provider.dart';

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
  _FakeSpringRepository(this.springs, {this.gate});

  /// Mutable so a test can change what the backend serves between fetches.
  List<SpringMarkerEntity> springs;

  /// When set, the **first** request parks on this future — lets a test land a
  /// second camera change while a fetch is still open.
  final Future<void>? gate;
  bool _gatePassed = false;

  /// Number of times the map-markers endpoint was hit — lets a test assert the
  /// coverage short-circuit (and its forced bypass) actually control fetching.
  int fetchCount = 0;

  @override
  Future<ApiResult<List<SpringMarkerEntity>>> fetchMapMarkers(
    SpringBounds bounds,
  ) async {
    fetchCount++;
    if (gate != null && !_gatePassed) {
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
    LatLng? origin,
    int limit = 5,
    String? locale,
  }) async {
    return const ApiResult.success([]);
  }
}

ProviderContainer _containerWith(
  _FakeSpringRepository repository, {
  SpringMarkerSource? source,
}) {
  final container = ProviderContainer(
    overrides: [
      springRepositoryProvider.overrideWithValue(repository),
      if (source != null) springMarkerSourceProvider.overrideWithValue(source),
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

    await notifier.onCameraChanged(_wideBounds, 18);

    final items = container.read(mapMarkerProvider).items;
    expect(items.whereType<SpringPoint>().length, 3);
    expect(items.whereType<Cluster>(), isEmpty);
  });

  test('groups nearby springs into fewer items at low zoom', () async {
    final container = _containerWith(
      _FakeSpringRepository([_prague, _pragueNear, _zdar]),
    );
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.onCameraChanged(_wideBounds, 5);

    final items = container.read(mapMarkerProvider).items;
    expect(items.length, lessThan(3));
    expect(items.whereType<Cluster>(), isNotEmpty);
  });

  test('clusters only the springs inside the camera window', () async {
    final container = _containerWith(
      _FakeSpringRepository([_prague, _pragueNear, _zdar]),
    );
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.onCameraChanged(_pragueBounds, 18);
    expect(
      container.read(mapMarkerProvider).items.whereType<SpringPoint>().length,
      2,
    );

    await notifier.onCameraChanged(_wideBounds, 18);
    expect(
      container.read(mapMarkerProvider).items.whereType<SpringPoint>().length,
      3,
    );
  });

  test('returning to a visited area does not re-fetch', () async {
    final repository = _FakeSpringRepository([_prague, _pragueNear, _zdar]);
    final container = _containerWith(repository);
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.onCameraChanged(_pragueBounds, 18);
    expect(repository.fetchCount, 1);

    // Zooming out reaches tiles Prague never covered, so this one is real.
    await notifier.onCameraChanged(_wideBounds, 10);
    expect(repository.fetchCount, 2);

    // Everything from here on is inside tiles already fetched. A rectangle-based
    // cache would re-request on each of these — that was the flicker.
    await notifier.onCameraChanged(_pragueBounds, 18);
    await notifier.onCameraChanged(_wideBounds, 10);
    await notifier.onCameraChanged(_pragueBounds, 18);

    expect(repository.fetchCount, 2);
  });

  test('panning inside the cluster window emits no state at all', () async {
    final container = _containerWith(
      _FakeSpringRepository([_prague, _pragueNear, _zdar]),
    );
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.onCameraChanged(_pragueBounds, 18);
    final state = container.read(mapMarkerProvider);

    // The very same state object, meaning nothing was emitted: the map page
    // never rebuilds and the marker layer stays exactly as it is.
    await notifier.onCameraChanged(_pragueBoundsNudged, 18);
    expect(identical(container.read(mapMarkerProvider), state), isTrue);

    // Leaving the window recomputes.
    await notifier.onCameraChanged(_wideBounds, 18);
    expect(container.read(mapMarkerProvider).items, isNot(state.items));
  });

  test('marks the visible bounds as loaded when no springs are returned', () async {
    final container = _containerWith(_FakeSpringRepository([]));
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.onCameraChanged(_pragueBounds, 18);

    final state = container.read(mapMarkerProvider);
    expect(state.items, isEmpty);
    expect(state.visibleBoundsLoaded, isTrue);
  });

  test('re-fetches a tile once its time-to-live expires', () async {
    final repository = _FakeSpringRepository([_prague, _pragueNear]);
    var now = DateTime(2026, 7, 21, 12);
    final container = _containerWith(
      repository,
      source: TileGridSpringMarkerSource(
        repository,
        clock: () => now,
        maxAge: const Duration(minutes: 5),
      ),
    );
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.onCameraChanged(_pragueBounds, 18);
    expect(repository.fetchCount, 1);

    // Still fresh two minutes on: a browsing session must not re-request.
    now = now.add(const Duration(minutes: 2));
    await notifier.onCameraChanged(_pragueBounds, 18);
    expect(repository.fetchCount, 1);

    // Past the TTL the same camera is refreshed, so a report submitted
    // meanwhile shows up.
    now = now.add(const Duration(minutes: 5));
    await notifier.onCameraChanged(_pragueBounds, 18);
    expect(repository.fetchCount, 2);

    // A stale tile still has data to draw, so the area never reads as unloaded
    // and the map keeps its markers while the refresh runs.
    expect(container.read(mapMarkerProvider).visibleBoundsLoaded, isTrue);
    expect(
      container.read(mapMarkerProvider).items.whereType<SpringPoint>().length,
      2,
    );
  });

  test('a spring whose coordinates moved between tiles is not duplicated', () async {
    final repository = _FakeSpringRepository([_prague, _pragueNear, _zdar]);
    var now = DateTime(2026, 7, 21, 12);
    final container = _containerWith(
      repository,
      source: TileGridSpringMarkerSource(repository, clock: () => now),
    );
    final notifier = container.read(mapMarkerProvider.notifier);

    // Caches Prague's tile and Žďár's tile in one go — Prague's is created
    // first, so it is also walked first when reading the cache back.
    await notifier.onCameraChanged(_wideBounds, 10);
    expect(container.read(springMarkersProvider).springs.length, 3);

    // The backend corrects c's coordinates, far enough to land in Prague's tile.
    final moved = _zdar.copyWith(position: const LatLng(50.082, 14.423));
    repository.springs = [_prague, _pragueNear, moved];

    // Past the TTL a Prague camera refreshes only Prague's tile. Žďár's tile
    // keeps its stale copy of c — and is read *after* the refreshed one, so
    // taking "the last one seen" would resurrect the old position.
    now = now.add(const Duration(minutes: 10));
    await notifier.onCameraChanged(_pragueBounds, 18);

    final springs = container.read(springMarkersProvider).springs;
    expect(springs.map((spring) => spring.documentId), ['a', 'b', 'c']);
    expect(
      springs.firstWhere((spring) => spring.documentId == 'c').position,
      moved.position,
    );
  });

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
    final first = notifier.onCameraChanged(_pragueBounds, 18);
    final second = notifier.onCameraChanged(_wideBounds, 18);
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

    await notifier.onCameraChanged(_pragueBounds, 18);
    expect(repository.fetchCount, 1);

    // Re-reporting the same (cached) camera must NOT hit the network.
    await notifier.onCameraChanged(_pragueBounds, 18);
    expect(repository.fetchCount, 1);

    // refreshVisible bypasses the cache and re-verifies via a real request —
    // the recovery path used on app resume while offline.
    await notifier.refreshVisible();
    expect(repository.fetchCount, 2);
  });

  test('an unchanged refresh leaves the springs and the markers alone', () async {
    final container = _containerWith(_FakeSpringRepository([_prague]));
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.onCameraChanged(_pragueBounds, 18);
    final springs = container.read(springMarkersProvider).springs;
    final items = container.read(mapMarkerProvider).items;

    // The resume probe re-fetches; unchanged data must not duplicate springs or
    // disturb what is drawn.
    await notifier.refreshVisible();

    expect(container.read(springMarkersProvider).springs, springs);
    expect(container.read(mapMarkerProvider).items, items);
  });

  test('refreshVisible is a no-op before the first camera is reported', () async {
    final repository = _FakeSpringRepository([_prague]);
    final container = _containerWith(repository);
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.refreshVisible();
    expect(repository.fetchCount, 0);
  });
}
