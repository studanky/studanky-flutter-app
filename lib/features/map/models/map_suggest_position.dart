import 'package:json_annotation/json_annotation.dart';

part 'map_suggest_position.g.dart';

@JsonSerializable()
class MapSuggestPosition {
  const MapSuggestPosition({this.lat, this.lon});

  factory MapSuggestPosition.fromJson(Map<String, dynamic> json) =>
      _$MapSuggestPositionFromJson(json);

  final double? lat;
  final double? lon;

  Map<String, dynamic> toJson() => _$MapSuggestPositionToJson(this);
}
