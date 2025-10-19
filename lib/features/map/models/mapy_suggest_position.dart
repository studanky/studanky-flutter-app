import 'package:json_annotation/json_annotation.dart';

part 'mapy_suggest_position.g.dart';

@JsonSerializable()
class MapySuggestPosition {
  const MapySuggestPosition({this.lat, this.lon});

  factory MapySuggestPosition.fromJson(Map<String, dynamic> json) =>
      _$MapySuggestPositionFromJson(json);

  final double? lat;
  final double? lon;

  Map<String, dynamic> toJson() => _$MapySuggestPositionToJson(this);
}
