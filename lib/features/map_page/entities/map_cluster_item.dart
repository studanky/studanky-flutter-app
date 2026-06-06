import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

part 'map_cluster_item.freezed.dart';

/// A single drawable element produced by clustering for the current viewport
/// and zoom: either a grouped [Cluster] badge or an individual [SpringPoint].
@freezed
sealed class MapClusterItem with _$MapClusterItem {
  /// A group of [count] springs centred at [position]. Tapping should zoom to
  /// [expansionZoom] (the level at which the cluster breaks apart).
  const factory MapClusterItem.cluster({
    required LatLng position,
    required int count,
    required double expansionZoom,
  }) = Cluster;

  /// A single, un-clustered spring.
  const factory MapClusterItem.spring(SpringMarkerEntity spring) = SpringPoint;
}
