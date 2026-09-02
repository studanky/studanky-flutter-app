import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_cluster_item.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/features/springs/providers/spring_markers_provider.dart';
import 'package:supercluster/supercluster.dart';

part 'map_marker_provider.freezed.dart';

final mapMarkerProvider =
    NotifierProvider.autoDispose<MapMarkerNotifier, MapMarkerState>(
      MapMarkerNotifier.new,
    );

@freezed
abstract class MapMarkerState with _$MapMarkerState {
  const factory MapMarkerState({
    /// Loading/error of the background fetch, mirrored from
    /// [springMarkersProvider]. Items stay visible while a fetch runs, so this
    /// is a thin status channel, not the source of markers.
    @Default(AsyncValue<void>.data(null)) AsyncValue<void> status,

    /// Clustered, drawable items for the most recent camera.
    @Default(<MapClusterItem>[]) List<MapClusterItem> items,

    /// True once the visible camera bounds are covered by fetched marker data.
    /// Lets the UI distinguish a real empty viewport from one that is still
    /// waiting for its first fetch. Prefetch-ring coverage is deliberately not
    /// part of this presentation flag.
    @Default(false) bool visibleBoundsLoaded,

    /// Whether at least one drawable marker or cluster anchor is inside the
    /// exact visible camera bounds. [items] deliberately spans the padded data
    /// window, so its non-emptiness cannot answer whether the user sees data.
    @Default(false) bool hasVisibleMarkers,
  }) = _MapMarkerState;
}

/// Projects (dataset × camera) onto the drawable marker items, and asks
/// [springMarkersProvider] to make sure the camera's padded data window is
/// loaded.
///
/// Owns no springs and performs no fetching itself — deliberately, because both
/// outlive this notifier: it is `autoDispose`, so a map page that goes away and
/// comes back re-clusters from the session cache without touching the network.
/// Clustering is synchronous and cheap, and is skipped outright while the
/// camera stays inside the window the current items were computed for.
class MapMarkerNotifier extends Notifier<MapMarkerState> {
  /// Fraction of each viewport extent added on every edge by [_dataWindow].
  static const double _dataWindowPadding = 0.2;

  /// Pixel radius within which points merge, and the max zoom the index builds
  /// to. Keep [_clusterMaxZoom] aligned with the map's max zoom.
  static const int _clusterRadius = 80;
  static const int _clusterMaxZoom = 18;

  Supercluster<SpringMarkerEntity>? _index;

  LatLngBounds? _lastVisibleBounds;
  double _lastZoom = 0;

  /// Padded bounds and zoom level the current [MapMarkerState.items] were
  /// clustered for. Null means "recompute on the next camera report".
  LatLngBounds? _clusterWindow;
  int? _clusterWindowZoom;

  @override
  MapMarkerState build() {
    ref.listen<SpringMarkersState>(springMarkersProvider, _onDatasetChanged);

    // Adopt whatever the session cache already holds, so a map page that comes
    // back re-clusters from memory instead of re-fetching.
    final dataset = ref.read(springMarkersProvider);
    _rebuildIndex(dataset.springs);

    return MapMarkerState(status: dataset.status);
  }

  /// Marks cached coverage stale for a new locale without replacing the
  /// marker/index state. Complete old-locale markers intentionally remain as
  /// placeholders — including their localized names used by accessibility and
  /// the provisional detail header — until the cluster window is refreshed.
  void onLanguageTagChanged(String languageTag) {
    ref.read(springMarkersProvider.notifier).updateLanguageTag(languageTag);
  }

  /// Call on map ready and after each (debounced) camera change. Reclusters
  /// from the cache immediately, then ensures the area is loaded — which is a
  /// no-op for tiles already fetched and still fresh.
  Future<void> onCameraChanged(
    LatLngBounds visibleBounds,
    double zoom, {
    required String languageTag,
  }) {
    _lastVisibleBounds = visibleBounds;
    _lastZoom = zoom;
    _publish();
    return ref
        .read(springMarkersProvider.notifier)
        .ensureLoaded(
          _toSpringBounds(_dataWindow(visibleBounds)),
          languageTag: languageTag,
        );
  }

  /// Re-fetches the visible camera's padded data window even though it is
  /// cached and fresh. Reserved for the resume-while-offline probe: only a real
  /// request can discover that the network came back, and its outcome drives
  /// the offline banner. No-op until the first camera has been reported.
  Future<void> refreshVisible({required String languageTag}) async {
    final bounds = _lastVisibleBounds;
    if (bounds == null) return;
    await ref
        .read(springMarkersProvider.notifier)
        .ensureLoaded(
          _toSpringBounds(_dataWindow(bounds)),
          languageTag: languageTag,
          force: true,
        );
  }

  /// The dataset is the only thing that invalidates the cluster index — camera
  /// changes merely re-search it. Status and loaded-ness ride along so the map
  /// page reads one state object.
  void _onDatasetChanged(
    SpringMarkersState? previous,
    SpringMarkersState next,
  ) {
    // Value equality, not identity: freezed hands out a fresh
    // `EqualUnmodifiableListView` on every `springs` read, so identity would
    // never match and the index would be rebuilt on every status flip.
    if (!listEquals(previous?.springs, next.springs)) {
      _rebuildIndex(next.springs);
    }

    _publish(status: next.status);
  }

  /// Writes the state for the current camera and dataset — but only when
  /// something actually changed. Skipping the write is what keeps an ordinary
  /// pan from rebuilding the map page at all; the deep equality freezed
  /// generates would suppress the notification anyway, but not the work of
  /// comparing every clustered item to decide that.
  void _publish({AsyncValue<void>? status}) {
    final items = _clusterItems();
    final nextItems = items ?? state.items;
    final loaded = _isVisibleBoundsLoaded();
    final hasVisibleMarkers = _hasVisibleMarkers(nextItems);
    final nextStatus = status ?? state.status;

    if (items == null &&
        loaded == state.visibleBoundsLoaded &&
        hasVisibleMarkers == state.hasVisibleMarkers &&
        nextStatus == state.status) {
      return;
    }

    state = state.copyWith(
      status: nextStatus,
      visibleBoundsLoaded: loaded,
      hasVisibleMarkers: hasVisibleMarkers,
      items: nextItems,
    );
  }

  bool _hasVisibleMarkers(List<MapClusterItem> items) {
    final bounds = _lastVisibleBounds;
    if (bounds == null) return false;

    return items.any((item) {
      final position = switch (item) {
        Cluster(:final position) => position,
        SpringPoint(:final spring) => spring.position,
      };
      return bounds.contains(position);
    });
  }

  bool _isVisibleBoundsLoaded() {
    final bounds = _lastVisibleBounds;
    if (bounds == null) return false;
    final languageTag = ref.read(springMarkersProvider).languageTag;
    if (languageTag == null) return false;
    return ref
        .read(springMarkersProvider.notifier)
        .hasDataFor(_toSpringBounds(bounds), languageTag: languageTag);
  }

  /// Clusters the current camera's window, or returns null when the existing
  /// [MapMarkerState.items] still apply and the marker layer should be left
  /// alone.
  List<MapClusterItem>? _clusterItems() {
    final bounds = _lastVisibleBounds;
    if (bounds == null) return null;

    final zoomLevel = _lastZoom.round().clamp(0, _clusterMaxZoom);
    if (zoomLevel == _clusterWindowZoom &&
        (_clusterWindow?.containsBounds(bounds) ?? false)) {
      return null;
    }

    final index = _index;
    if (index == null) {
      return state.items.isEmpty ? null : const <MapClusterItem>[];
    }

    final window = _dataWindow(bounds);
    final elements = index.search(
      window.west,
      window.south,
      window.east,
      window.north,
      zoomLevel,
    );

    _clusterWindow = window;
    _clusterWindowZoom = zoomLevel;

    return elements
        .map((element) => _toItem(index, element))
        .toList(growable: false);
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

  void _rebuildIndex(List<SpringMarkerEntity> springs) {
    _index = springs.isEmpty
        ? null
        : (SuperclusterImmutable<SpringMarkerEntity>(
            getX: (spring) => spring.position.longitude,
            getY: (spring) => spring.position.latitude,
            maxZoom: _clusterMaxZoom,
            radius: _clusterRadius,
          )..load(springs));

    // Cluster composition changed underneath the current items: recompute
    // wherever the camera happens to be.
    _clusterWindow = null;
    _clusterWindowZoom = null;
  }

  SpringBounds _toSpringBounds(LatLngBounds bounds) => SpringBounds(
    north: bounds.north,
    south: bounds.south,
    east: bounds.east,
    west: bounds.west,
  );

  /// The shared clustering and fetch window deliberately includes a prefetch
  /// ring, not just the visible viewport. It makes small pans reveal complete,
  /// locale-current marker data without rebuilding the layer. Padding each edge
  /// by 20% can make the raw rectangle up to 1.96x the viewport area. The
  /// 0.5-degree tile grid usually absorbs it at browsing zoom; at low zoom it
  /// can add edge rows or columns of tiles to the request.
  LatLngBounds _dataWindow(LatLngBounds bounds) {
    if (_dataWindowPadding == 0) return bounds;

    final latExtent = bounds.north - bounds.south;
    final lonExtent = bounds.longitudeWidth;

    final latPadding = latExtent * _dataWindowPadding;
    final lonPadding = lonExtent * _dataWindowPadding;

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
