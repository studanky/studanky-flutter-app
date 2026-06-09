import 'package:json_annotation/json_annotation.dart';

part 'favorite_spring_dto.g.dart';

/// Persisted shape of a favourited spring (SharedPreferences, JSON). Carries the
/// minimal summary the favourites list and detail need so it works fully
/// offline: identity, name, position and the last-known status.
@JsonSerializable()
class FavoriteSpringDto {
  const FavoriteSpringDto({
    required this.documentId,
    required this.name,
    required this.lat,
    required this.lng,
    required this.status,
    this.statusUpdatedAt,
  });

  factory FavoriteSpringDto.fromJson(Map<String, dynamic> json) =>
      _$FavoriteSpringDtoFromJson(json);

  final String documentId;
  final String name;
  final double lat;
  final double lng;

  /// Raw `current_status` wire value (see `SpringStatus`).
  final String status;

  final DateTime? statusUpdatedAt;

  Map<String, dynamic> toJson() => _$FavoriteSpringDtoToJson(this);
}
