import 'dart:math' as math;

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:studanky_flutter_app/features/map/data/map_marker_source.dart';
import 'package:studanky_flutter_app/features/map/models/map_marker.dart';

/// Immutable snapshot consumed by the `MarkerLayer`.
///
/// - [loadedMarkers] are the markers fetched for the most recent viewport.
/// - [customMarkers] are taps dropped by the user that should stay visible.
/// - [cachedBounds] tracks the padded viewport covered by [loadedMarkers].
/// - [pendingBounds] queues the next viewport while a fetch is in-flight.
class MapMarkerState {
  const MapMarkerState({
    this.loadedMarkers = const [],
    this.customMarkers = const [],
    this.isLoading = false,
    this.cachedBounds,
    this.pendingBounds,
  });

  final List<MapMarker> loadedMarkers;
  final List<MapMarker> customMarkers;
  final bool isLoading;
  final LatLngBounds? cachedBounds;
  final LatLngBounds? pendingBounds;

  /// Combined list of markers that should currently be rendered.
  List<MapMarker> get visibleMarkers => [...loadedMarkers, ...customMarkers];

  /// Copies this state with optional overrides.
  ///
  /// [pendingBounds] accepts an [Object] so callers can explicitly set it to
  /// `null` without colliding with the optional parameter defaults.
  MapMarkerState copyWith({
    List<MapMarker>? loadedMarkers,
    List<MapMarker>? customMarkers,
    bool? isLoading,
    LatLngBounds? cachedBounds,
    Object? pendingBounds = _sentinel,
  }) {
    return MapMarkerState(
      loadedMarkers: loadedMarkers ?? this.loadedMarkers,
      customMarkers: customMarkers ?? this.customMarkers,
      isLoading: isLoading ?? this.isLoading,
      cachedBounds: cachedBounds ?? this.cachedBounds,
      pendingBounds: pendingBounds == _sentinel
          ? this.pendingBounds
          : pendingBounds as LatLngBounds?,
    );
  }

  static const _sentinel = Object();
}

/// Provides the backing marker source (in-memory for now, API later).
final mapMarkerSourceProvider = Provider<MapMarkerSource>((ref) {
  return InMemoryMapMarkerSource(
    markers: const [
      MapMarker(position: LatLng(49.5638, 15.9398), label: 'Zelená hora'),
      MapMarker(position: LatLng(49.5613, 15.9380), label: 'Town Square'),
      MapMarker(position: LatLng(49.5695, 15.9482), label: 'Pilská Reservoir'),
      MapMarker(
        position: LatLng(49.5554, 15.9301),
        label: 'Sádek Forest Trail',
      ),
      MapMarker(position: LatLng(49.5842, 15.9556), label: 'Sv. Jan Well'),
      MapMarker(position: LatLng(50.0755, 14.4378), label: 'Prague Old Town'),
    ],
  );
});

/// Exposes the notifier that orchestrates loading and custom marker updates.
final mapMarkerNotifierProvider =
    AutoDisposeNotifierProvider<MapMarkerNotifier, MapMarkerState>(
      MapMarkerNotifier.new,
    );

/// Handles lazy-loading and exposes marker state to the UI.
class MapMarkerNotifier extends AutoDisposeNotifier<MapMarkerState> {
  static const double _boundsPaddingFraction = 0.2;

  MapMarkerSource get _source => ref.read(mapMarkerSourceProvider);

  @override
  MapMarkerState build() => const MapMarkerState();

  Future<void> refreshVisibleBounds(LatLngBounds bounds) async {
    final requestBounds = _expandBounds(bounds);
    final cached = state.cachedBounds;
    if (cached != null && cached.containsBounds(requestBounds)) return;

    state = state.copyWith(pendingBounds: requestBounds);

    if (state.isLoading) return;

    await _drainPendingLoads();
  }

  /// Stores a user-created marker without triggering a fetch.
  void addCustomMarker(MapMarker marker) {
    state = state.copyWith(customMarkers: [...state.customMarkers, marker]);
  }

  /// Clears all custom markers from the current snapshot.
  void clearCustomMarkers() {
    if (state.customMarkers.isEmpty) {
      return;
    }
    state = state.copyWith(customMarkers: const []);
  }

  /// Sequentially drains queued viewport fetches, keeping the latest result.
  Future<void> _drainPendingLoads() async {
    while (true) {
      final pending = state.pendingBounds;
      if (pending == null) {
        break;
      }

      state = state.copyWith(pendingBounds: null, isLoading: true);

      try {
        final fetched = await _source.loadMarkers(pending);
        state = state.copyWith(
          loadedMarkers: List<MapMarker>.unmodifiable(fetched),
          cachedBounds: pending,
          isLoading: false,
        );
      } catch (error, stackTrace) {
        Logger().e(
          '[MapMarkerNotifier] Failed to load markers',
          error: error,
          stackTrace: stackTrace,
        );
        state = state.copyWith(isLoading: false);
      }
    }
  }

  /// Expands the requested bounds to prefetch nearby markers.
  LatLngBounds _expandBounds(LatLngBounds bounds) {
    if (_boundsPaddingFraction == 0) {
      return bounds;
    }

    final latExtent = bounds.north - bounds.south;
    final lonExtent = bounds.longitudeWidth;

    final latPadding = latExtent * _boundsPaddingFraction;
    final lonPadding = lonExtent * _boundsPaddingFraction;

    final double north = math.min(
      LatLngBounds.maxLatitude,
      bounds.north + latPadding,
    );
    final double south = math.max(
      LatLngBounds.minLatitude,
      bounds.south - latPadding,
    );
    final double east = math.min(
      LatLngBounds.maxLongitude,
      bounds.east + lonPadding,
    );
    final double west = math.max(
      LatLngBounds.minLongitude,
      bounds.west - lonPadding,
    );

    return LatLngBounds.unsafe(
      north: north,
      south: south,
      east: east,
      west: west,
    );
  }
}
