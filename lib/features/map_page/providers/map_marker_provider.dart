import 'dart:math' as math;

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_marker_entity.dart';
import 'package:studanky_flutter_app/features/map_shared/providers/map_marker_repository_provider.dart';
import 'package:studanky_flutter_app/features/map_shared/repositories/map_marker_repository.dart';

final mapMarkerProvider =
    NotifierProvider.autoDispose<MapMarkerNotifier, MapMarkerState>(
      MapMarkerNotifier.new,
    );

class MapMarkerState {
  const MapMarkerState({
    this.loadedMarkers = const <MapMarkerEntity>[],
    this.customMarkers = const <MapMarkerEntity>[],
    this.isLoading = false,
    this.cachedBounds,
    this.pendingBounds,
  });

  final List<MapMarkerEntity> loadedMarkers;
  final List<MapMarkerEntity> customMarkers;
  final bool isLoading;
  final LatLngBounds? cachedBounds;
  final LatLngBounds? pendingBounds;

  List<MapMarkerEntity> get visibleMarkers =>
      List.unmodifiable(<MapMarkerEntity>[...loadedMarkers, ...customMarkers]);

  MapMarkerState copyWith({
    List<MapMarkerEntity>? loadedMarkers,
    List<MapMarkerEntity>? customMarkers,
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

  static const Object _sentinel = Object();
}

class MapMarkerNotifier extends Notifier<MapMarkerState> {
  MapMarkerRepository get _repository => ref.read(mapMarkerRepositoryProvider);

  static const double _boundsPaddingFraction = 0.2;
  final Logger _logger = Logger('MapMarkerNotifier');

  @override
  MapMarkerState build() => const MapMarkerState();

  Future<void> refreshVisibleBounds(LatLngBounds bounds) async {
    final requestBounds = _expandBounds(bounds);
    final cached = state.cachedBounds;
    if (cached != null && cached.containsBounds(requestBounds)) {
      return;
    }

    state = state.copyWith(pendingBounds: requestBounds);

    if (state.isLoading) {
      return;
    }

    await _drainPendingLoads();
  }

  void addCustomMarker(MapMarkerEntity marker) {
    state = state.copyWith(
      customMarkers: <MapMarkerEntity>[...state.customMarkers, marker],
    );
  }

  void clearCustomMarkers() {
    if (state.customMarkers.isEmpty) {
      return;
    }
    state = state.copyWith(customMarkers: const <MapMarkerEntity>[]);
  }

  Future<void> _drainPendingLoads() async {
    while (true) {
      final pending = state.pendingBounds;
      if (pending == null) {
        break;
      }

      state = state.copyWith(pendingBounds: null, isLoading: true);

      try {
        final fetched = await _repository.fetchMarkers(pending);
        state = state.copyWith(
          loadedMarkers: List.unmodifiable(fetched),
          cachedBounds: pending,
          isLoading: false,
        );
      } catch (error, stackTrace) {
        _logger.severe('Failed to load markers', error, stackTrace);
        state = state.copyWith(isLoading: false);
      }
    }
  }

  LatLngBounds _expandBounds(LatLngBounds bounds) {
    if (_boundsPaddingFraction == 0) {
      return bounds;
    }

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
