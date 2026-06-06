import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/springs/dtos/spring_map_marker_dto.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';

class SpringMapMarkerMapper {
  const SpringMapMarkerMapper._();

  static SpringMarkerEntity fromDto(SpringMapMarkerDto dto) {
    return SpringMarkerEntity(
      documentId: dto.documentId,
      name: dto.name,
      position: LatLng(dto.lat, dto.lng),
      status: SpringStatus.fromWire(dto.currentStatus),
      statusUpdatedAt: dto.statusUpdatedAt,
    );
  }
}
