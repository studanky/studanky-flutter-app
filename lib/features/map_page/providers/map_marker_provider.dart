import 'dart:math' as math;

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_cluster_item.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_repository.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:supercluster/supercluster.dart';

part 'map_marker_provider.freezed.dart';

final mapMarkerProvider =
    NotifierProvider.autoDispose<MapMarkerNotifier, MapMarkerState>(
      MapMarkerNotifier.new,
    );

@freezed
abstract class MapMarkerState with _$MapMarkerState {
  const factory MapMarkerState({
    /// Loading/error of the background fetch. Items stay visible while a new
    /// fetch runs, so this is a thin status channel, not the source of markers.
    @Default(AsyncValue<void>.data(null)) AsyncValue<void> status,

    /// Clustered, drawable items for the most recent camera.
    @Default(<MapClusterItem>[]) List<MapClusterItem> items,

    /// True once the currently visible camera bounds are covered by fetched
    /// marker data. Lets the UI distinguish a real empty map area from a camera
    /// position that is still waiting for its first fetch.
    @Default(false) bool visibleBoundsLoaded,
  }) = _MapMarkerState;
}

/// Owns viewport fetching, an in-session marker cache and the supercluster
/// index. Reclustering is synchronous and cheap (run on every camera change);
/// network fetches are short-circuited by a cached-bounds check and coalesced
/// by the caller debouncing camera events.
class MapMarkerNotifier extends Notifier<MapMarkerState> {
  SpringRepository get _repository => ref.read(springRepositoryProvider);

  final Logger _logger = Logger('MapMarkerNotifier');

  /// Prefetch margin so small pans don't trigger a refetch.
  static const double _boundsPaddingFraction = 0.2;

  /// Pixel radius within which points merge, and the max zoom the index builds
  /// to. Keep [_clusterMaxZoom] aligned with the map's max zoom.
  static const int _clusterRadius = 80;
  static const int _clusterMaxZoom = 18;

  /// Session cache of every spring fetched so far, deduped by documentId.
  final Map<String, SpringMarkerEntity> _springsById = {};
  Supercluster<SpringMarkerEntity>? _index;

  LatLngBounds? _cachedBounds;
  LatLngBounds? _lastVisibleBounds;
  double _lastZoom = 0;

  bool _isFetching = false;
  LatLngBounds? _pendingFetchBounds;

  @override
  MapMarkerState build() => const MapMarkerState();

  /// Call on map ready and after each (debounced) camera change. Reclusters
  /// immediately from the cache, then fetches the area if it isn't covered yet.
  Future<void> onCameraChanged(LatLngBounds visibleBounds, double zoom) async {
    _lastVisibleBounds = visibleBounds;
    _lastZoom = zoom;
    _recomputeItems();
    await _maybeFetch(visibleBounds);
  }

  void _recomputeItems() {
    final index = _index;
    final bounds = _lastVisibleBounds;
    final visibleBoundsLoaded =
        bounds != null && (_cachedBounds?.containsBounds(bounds) ?? false);

    if (index == null || bounds == null) {
      if (state.visibleBoundsLoaded != visibleBoundsLoaded) {
        state = state.copyWith(visibleBoundsLoaded: visibleBoundsLoaded);
      }
      return;
    }

    final elements = index.search(
      bounds.west,
      bounds.south,
      bounds.east,
      bounds.north,
      _lastZoom.round().clamp(0, _clusterMaxZoom),
    );

    state = state.copyWith(
      items: elements
          .map((element) => _toItem(index, element))
          .toList(growable: false),
      visibleBoundsLoaded: visibleBoundsLoaded,
    );
  }

  MapClusterItem _toItem(
    Supercluster<SpringMarkerEntity> index,
    LayerElement<SpringMarkerEntity> element,
  ) {
    return element.handle(
      cluster: (cluster) => MapClusterItem.cluster(
        position: LatLng(cluster.latitude, cluster.longitude),
        count: cluster.childPointCount,
        expansionZoom: _expansionZoomOf(index, cluster).toDouble(),
      ),
      point: (point) => MapClusterItem.spring(point.originalPoint),
    );
  }

  int _expansionZoomOf(
    Supercluster<SpringMarkerEntity> index,
    LayerCluster<SpringMarkerEntity> cluster,
  ) {
    if (index is SuperclusterImmutable<SpringMarkerEntity> &&
        cluster is ImmutableLayerCluster<SpringMarkerEntity>) {
      return index.expansionZoomOf(cluster.id);
    }
    return (cluster.highestZoom + 1).clamp(0, _clusterMaxZoom);
  }

  /// Re-fetches the current visible bounds even if they're already cached.
  /// Used on app resume to re-verify connectivity through a real request (the
  /// outcome drives the offline banner), which the cache short-circuit would
  /// otherwise skip. No-op until the first camera has been reported.
  Future<void> refreshVisible() async {
    final bounds = _lastVisibleBounds;
    if (bounds == null) return;
    await _maybeFetch(bounds, force: true);
  }

  Future<void> _maybeFetch(LatLngBounds visibleBounds, {bool force = false}) async {
    final requestBounds = _expandBounds(visibleBounds);
    final cached = _cachedBounds;
    if (!force && cached != null && cached.containsBounds(requestBounds)) {
      return;
    }

    _pendingFetchBounds = requestBounds;
    if (_isFetching) return;
    await _drainPendingLoads();
  }

  Future<void> _drainPendingLoads() async {
    _isFetching = true;
    try {
      while (_pendingFetchBounds != null) {
        final bounds = _pendingFetchBounds!;
        _pendingFetchBounds = null;

        state = state.copyWith(status: const AsyncValue<void>.loading());

        final result = await _repository.fetchMapMarkers(
          _toSpringBounds(bounds),
        );

        switch (result) {
          case Success(:final data):
            for (final spring in data) {
              _springsById[spring.documentId] = spring;
            }
            _cachedBounds = bounds;
            _rebuildIndex();
            _recomputeItems();
            state = state.copyWith(status: const AsyncValue<void>.data(null));
          case Failure(:final exception):
            _logger.severe('Failed to load springs', exception);
            state = state.copyWith(
              status: AsyncValue<void>.error(exception, StackTrace.current),
            );
        }
      }
    } finally {
      _isFetching = false;
    }
  }

  void _rebuildIndex() {
    final index = SuperclusterImmutable<SpringMarkerEntity>(
      getX: (spring) => spring.position.longitude,
      getY: (spring) => spring.position.latitude,
      maxZoom: _clusterMaxZoom,
      radius: _clusterRadius,
    )..load(_springsById.values.toList(growable: false));
    _index = index;
  }

  SpringBounds _toSpringBounds(LatLngBounds bounds) => SpringBounds(
    north: bounds.north,
    south: bounds.south,
    east: bounds.east,
    west: bounds.west,
  );

  LatLngBounds _expandBounds(LatLngBounds bounds) {
    if (_boundsPaddingFraction == 0) return bounds;

    final latExtent = bounds.north - bounds.south;
    final lonExtent = bounds.longitudeWidth;

    final latPadding = latExtent * _boundsPaddingFraction;
    final lonPadding = lonExtent * _boundsPaddingFraction;

    final north = math.min(LatLngBounds.maxLatitude, bounds.north + latPadding);
    final south = math.max(LatLngBounds.minLatitude, bounds.south - latPadding);
    final east = math.min(LatLngBounds.maxLongitude, bounds.east + lonPadding);
    final west = math.max(LatLngBounds.minLongitude, bounds.west - lonPadding);

    return LatLngBounds.unsafe(
      north: north,
      south: south,
      east: east,
      west: west,
    );
  }
}
