import 'dart:math' as math;

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_marker_entity.dart';
import 'package:studanky_flutter_app/features/spring_getter/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/spring_getter/entities/spring_entity.dart';
import 'package:studanky_flutter_app/features/spring_getter/providers/spring_repository_provider.dart';
import 'package:studanky_flutter_app/features/spring_getter/repositories/spring_repository.dart';

part 'map_marker_provider.freezed.dart';

final mapMarkerProvider =
    NotifierProvider.autoDispose<MapMarkerNotifier, MapMarkerState>(
      MapMarkerNotifier.new,
    );

@freezed
abstract class MapMarkerState with _$MapMarkerState {
  const factory MapMarkerState({
    @Default(AsyncValue<List<MapMarkerEntity>>.data(<MapMarkerEntity>[]))
    AsyncValue<List<MapMarkerEntity>> markerResults,
    @Default(<MapMarkerEntity>[]) List<MapMarkerEntity> customMarkers,
    @Default(null) LatLngBounds? cachedBounds,
    @Default(null) LatLngBounds? pendingBounds,
  }) = _MapMarkerState;

  const MapMarkerState._();

  List<MapMarkerEntity> get loadedMarkers =>
      markerResults.value ?? const <MapMarkerEntity>[];

  List<MapMarkerEntity> get visibleMarkers =>
      List.unmodifiable(<MapMarkerEntity>[...loadedMarkers, ...customMarkers]);
}

class MapMarkerNotifier extends Notifier<MapMarkerState> {
  SpringRepository get _springRepository => ref.read(springRepositoryProvider);

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

    if (state.markerResults.isLoading) {
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

      state = state.copyWith(
        pendingBounds: null,
        markerResults: const AsyncValue<List<MapMarkerEntity>>.loading(),
      );

      try {
        final fetched = await _fetchMarkers(pending);
        state = state.copyWith(
          markerResults: AsyncValue<List<MapMarkerEntity>>.data(
            List.unmodifiable(fetched),
          ),
          cachedBounds: pending,
        );
      } catch (error, stackTrace) {
        _logger.severe('Failed to load markers', error, stackTrace);
        state = state.copyWith(
          markerResults: AsyncValue<List<MapMarkerEntity>>.error(
            error,
            stackTrace,
          ),
        );
      }
    }
  }

  Future<List<MapMarkerEntity>> _fetchMarkers(LatLngBounds bounds) async {
    final springs = await _springRepository.fetchSprings(
      SpringBounds(
        north: bounds.north,
        south: bounds.south,
        east: bounds.east,
        west: bounds.west,
      ),
    );
    return _convertSprings(springs);
  }

  List<MapMarkerEntity> _convertSprings(List<SpringEntity> springs) {
    return springs
        .map((spring) => MapMarkerEntity(position: spring.position))
        .toList(growable: false);
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
