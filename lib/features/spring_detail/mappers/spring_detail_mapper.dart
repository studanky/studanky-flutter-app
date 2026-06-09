import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/spring_detail/dtos/spring_detail_dto.dart';
import 'package:studanky_flutter_app/features/spring_detail/dtos/spring_media_dto.dart';
import 'package:studanky_flutter_app/features/spring_detail/dtos/spring_owner_dto.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/spring_detail.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/spring_owner.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/spring_photo.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';

class SpringDetailMapper {
  const SpringDetailMapper._();

  static SpringDetail fromDto(SpringDetailDto dto) {
    final description = dto.description?.trim();

    return SpringDetail(
      documentId: dto.documentId,
      name: dto.name,
      position: LatLng(dto.lat, dto.lng),
      status: SpringStatus.fromWire(dto.currentStatus),
      description: (description == null || description.isEmpty)
          ? null
          : description,
      statusUpdatedAt: dto.statusUpdatedAt,
      lastFlowScale: dto.lastFlowScale,
      lastFlowRateLps: dto.lastFlowRateLps,
      photo: _photoFromDto(dto.photo),
      owner: _ownerFromDto(dto.owner),
    );
  }

  static SpringPhoto? _photoFromDto(SpringMediaDto? dto) {
    if (dto == null || dto.url.isEmpty) return null;
    return SpringPhoto(
      url: dto.url,
      thumbnailUrl: dto.formats?.thumbnail?.url,
      width: dto.width,
      height: dto.height,
    );
  }

  static SpringOwner? _ownerFromDto(SpringOwnerDto? dto) {
    if (dto == null || dto.name.isEmpty) return null;
    return SpringOwner(name: dto.name, type: dto.type);
  }
}
