import 'package:json_annotation/json_annotation.dart';

part 'map_suggest_position_bo.g.dart';

@JsonSerializable()
class MapSuggestPositionBO {
  const MapSuggestPositionBO({required this.lat, required this.lon});

  factory MapSuggestPositionBO.fromJson(Map<String, dynamic> json) =>
      _$MapSuggestPositionBOFromJson(json);

  final double lat;
  final double lon;

  Map<String, dynamic> toJson() => _$MapSuggestPositionBOToJson(this);
}
