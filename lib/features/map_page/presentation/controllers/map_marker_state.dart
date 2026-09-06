import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_cluster_item.dart';

part 'map_marker_state.freezed.dart';

@freezed
abstract class MapMarkerState with _$MapMarkerState {
  const factory MapMarkerState({
    @Default(AsyncValue<void>.data(null)) AsyncValue<void> status,
    @Default(<MapClusterItem>[]) List<MapClusterItem> items,
    @Default(false) bool visibleBoundsLoaded,
    @Default(false) bool hasVisibleMarkers,
  }) = _MapMarkerState;
}
