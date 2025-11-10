import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'map_marker_entity.freezed.dart';

@freezed
abstract class MapMarkerEntity with _$MapMarkerEntity {
  const factory MapMarkerEntity({required LatLng position}) = _MapMarkerEntity;
}
