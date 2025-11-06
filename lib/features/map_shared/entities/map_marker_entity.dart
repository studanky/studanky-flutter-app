import 'package:latlong2/latlong.dart';

class MapMarkerEntity {
  const MapMarkerEntity({
    required this.position,
    this.label,
  });

  final LatLng position;
  final String? label;

  MapMarkerEntity copyWith({
    LatLng? position,
    String? label,
  }) {
    return MapMarkerEntity(
      position: position ?? this.position,
      label: label ?? this.label,
    );
  }
}
