import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_cluster_item.dart';
import 'package:studanky_flutter_app/features/map_page/providers/map_marker_provider.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_repository.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_search_result.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';

SpringMarkerEntity _spring(String id, double lat, double lng) =>
    SpringMarkerEntity(
      documentId: id,
      name: id,
      position: LatLng(lat, lng),
      status: SpringStatus.unknown,
    );

// Two springs ~150 m apart near Prague, one far away in Žďár.
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

/// Fake repository that returns the fixed springs falling inside the requested
/// bounds, mirroring what the real `GET /springs/map?bbox=` would serve.
class _FakeSpringRepository implements SpringRepository {
  _FakeSpringRepository(this._springs);

  final List<SpringMarkerEntity> _springs;

  /// Number of times the map-markers endpoint was hit — lets a test assert the
  /// cache short-circuit (and its forced bypass) actually control fetching.
  int fetchCount = 0;

  @override
  Future<ApiResult<List<SpringMarkerEntity>>> fetchMapMarkers(
    SpringBounds bounds,
  ) async {
    fetchCount++;
    final inBounds = _springs
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

ProviderContainer _containerWith(List<SpringMarkerEntity> springs) {
  final container = ProviderContainer(
    overrides: [
      springRepositoryProvider.overrideWithValue(
        _FakeSpringRepository(springs),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('renders each spring individually at high zoom', () async {
    final container = _containerWith([_prague, _pragueNear, _zdar]);
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.onCameraChanged(_wideBounds, 18);

    final items = container.read(mapMarkerProvider).items;
    expect(items.whereType<SpringPoint>().length, 3);
    expect(items.whereType<Cluster>(), isEmpty);
  });

  test('groups nearby springs into fewer items at low zoom', () async {
    final container = _containerWith([_prague, _pragueNear, _zdar]);
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.onCameraChanged(_wideBounds, 5);

    final items = container.read(mapMarkerProvider).items;
    expect(items.length, lessThan(3));
    expect(items.whereType<Cluster>(), isNotEmpty);
  });

  test('accumulates new springs while deduping already-seen ones', () async {
    final container = _containerWith([_prague, _pragueNear, _zdar]);
    final notifier = container.read(mapMarkerProvider.notifier);

    // First fetch covers Prague only (a, b).
    await notifier.onCameraChanged(_pragueBounds, 18);
    expect(
      container.read(mapMarkerProvider).items.whereType<SpringPoint>().length,
      2,
    );

    // Panning out to include Žďár adds c; a and b must not be double-counted.
    await notifier.onCameraChanged(_wideBounds, 18);
    expect(
      container.read(mapMarkerProvider).items.whereType<SpringPoint>().length,
      3,
    );
  });

  test(
    'marks the visible bounds as loaded when no springs are returned',
    () async {
      final container = _containerWith([]);
      final notifier = container.read(mapMarkerProvider.notifier);

      await notifier.onCameraChanged(_pragueBounds, 18);

      final state = container.read(mapMarkerProvider);
      expect(state.items, isEmpty);
      expect(state.visibleBoundsLoaded, isTrue);
    },
  );

  test('refreshVisible forces a re-fetch of the current bounds past the cache', () async {
    final repository = _FakeSpringRepository([_prague]);
    final container = ProviderContainer(
      overrides: [springRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
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

  test('refreshVisible is a no-op before the first camera is reported', () async {
    final repository = _FakeSpringRepository([_prague]);
    final container = ProviderContainer(
      overrides: [springRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    final notifier = container.read(mapMarkerProvider.notifier);

    await notifier.refreshVisible();
    expect(repository.fetchCount, 0);
  });
}
