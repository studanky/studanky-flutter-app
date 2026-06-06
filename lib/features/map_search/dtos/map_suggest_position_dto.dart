import 'package:json_annotation/json_annotation.dart';

part 'map_suggest_position_dto.g.dart';

@JsonSerializable()
class MapSuggestPositionDto {
  const MapSuggestPositionDto({required this.lat, required this.lon});

  factory MapSuggestPositionDto.fromJson(Map<String, dynamic> json) =>
      _$MapSuggestPositionDtoFromJson(json);

  final double lat;
  final double lon;

  Map<String, dynamic> toJson() => _$MapSuggestPositionDtoToJson(this);
}
