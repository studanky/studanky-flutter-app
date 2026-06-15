import 'package:json_annotation/json_annotation.dart';

part 'spring_map_marker_dto.g.dart';

/// One item of the `GET /api/springs/map` payload — the minimal marker shape
/// (api-reference.md §3.1). This is a **custom flat endpoint**: fields sit
/// directly on the object (no Strapi `attributes` nesting).
///
/// Note the mixed key casing in the contract: `documentId` is camelCase while
/// `current_status` / `status_updated_at` are snake_case, so the snake keys are
/// annotated explicitly rather than via a blanket `fieldRename`.
@JsonSerializable()
class SpringMapMarkerDto {
  const SpringMapMarkerDto({
    required this.documentId,
    required this.name,
    required this.lat,
    required this.lng,
    required this.currentStatus,
    this.statusUpdatedAt,
    this.distanceMeters,
  });

  factory SpringMapMarkerDto.fromJson(Map<String, dynamic> json) =>
      _$SpringMapMarkerDtoFromJson(json);

  final String documentId;
  final String name;
  final double lat;
  final double lng;

  @JsonKey(name: 'current_status')
  final String currentStatus;

  /// ISO-8601 UTC timestamp of the latest report — the freshness anchor. Null
  /// when the spring has no report yet.
  @JsonKey(name: 'status_updated_at')
  final DateTime? statusUpdatedAt;

  /// Rounded distance from the requested search origin in metres. Only present
  /// on `GET /api/springs/search` when both `lat` and `lng` are valid.
  @JsonKey(name: 'distance_m')
  final int? distanceMeters;

  Map<String, dynamic> toJson() => _$SpringMapMarkerDtoToJson(this);
}
