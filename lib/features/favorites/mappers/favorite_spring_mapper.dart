import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/favorites/dtos/favorite_spring_dto.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';

/// Maps between the persisted [FavoriteSpringDto] and the in-memory
/// [SpringMarkerEntity] used across the app (map, detail, favourites).
class FavoriteSpringMapper {
  const FavoriteSpringMapper._();

  static SpringMarkerEntity fromDto(FavoriteSpringDto dto) {
    return SpringMarkerEntity(
      documentId: dto.documentId,
      name: dto.name,
      position: LatLng(dto.lat, dto.lng),
      status: SpringStatus.fromWire(dto.status),
      statusUpdatedAt: dto.statusUpdatedAt,
    );
  }

  static FavoriteSpringDto toDto(SpringMarkerEntity spring) {
    return FavoriteSpringDto(
      documentId: spring.documentId,
      name: spring.name,
      lat: spring.position.latitude,
      lng: spring.position.longitude,
      status: spring.status.wireValue,
      statusUpdatedAt: spring.statusUpdatedAt,
    );
  }
}
