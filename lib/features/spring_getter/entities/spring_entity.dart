import 'package:latlong2/latlong.dart';

class SpringEntity {
  const SpringEntity({required this.position, this.label});

  final LatLng position;
  final String? label;

  SpringEntity copyWith({LatLng? position, String? label}) {
    return SpringEntity(
      position: position ?? this.position,
      label: label ?? this.label,
    );
  }
}
