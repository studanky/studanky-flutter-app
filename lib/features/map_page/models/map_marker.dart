import 'package:latlong2/latlong.dart';

/// Domain model representing a single point placed on the map.
class MapMarker {
  const MapMarker({
    required this.position,
    this.label,
  });

  final LatLng position;
  final String? label;

  MapMarker copyWith({
    LatLng? position,
    String? label,
  }) {
    return MapMarker(
      position: position ?? this.position,
      label: label ?? this.label,
    );
  }
}
