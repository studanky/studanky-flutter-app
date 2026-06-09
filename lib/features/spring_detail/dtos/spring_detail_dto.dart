import 'package:json_annotation/json_annotation.dart';
import 'package:studanky_flutter_app/features/spring_detail/dtos/spring_media_dto.dart';
import 'package:studanky_flutter_app/features/spring_detail/dtos/spring_owner_dto.dart';

part 'spring_detail_dto.g.dart';

/// The `data` object of `GET /api/springs/:documentId` — the standard Strapi v5
/// shape with fields flattened onto `data` (api-reference.md §3.2). Relations
/// and media are present only when populated (`photo`, `owner`).
@JsonSerializable()
class SpringDetailDto {
  const SpringDetailDto({
    required this.documentId,
    required this.name,
    required this.lat,
    required this.lng,
    required this.currentStatus,
    this.description,
    this.statusUpdatedAt,
    this.lastFlowScale,
    this.lastFlowRateLps,
    this.photo,
    this.owner,
  });

  factory SpringDetailDto.fromJson(Map<String, dynamic> json) =>
      _$SpringDetailDtoFromJson(json);

  final String documentId;
  final String name;
  final String? description;
  final double lat;
  final double lng;

  @JsonKey(name: 'current_status')
  final String currentStatus;

  @JsonKey(name: 'status_updated_at')
  final DateTime? statusUpdatedAt;

  @JsonKey(name: 'last_flow_scale')
  final int? lastFlowScale;

  @JsonKey(name: 'last_flow_rate_lps')
  final double? lastFlowRateLps;

  final SpringMediaDto? photo;
  final SpringOwnerDto? owner;

  Map<String, dynamic> toJson() => _$SpringDetailDtoToJson(this);
}
