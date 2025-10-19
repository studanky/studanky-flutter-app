import 'package:json_annotation/json_annotation.dart';
import 'package:studanky_flutter_app/features/map/models/map_suggest_item.dart';

part 'map_suggest_response.g.dart';

@JsonSerializable(explicitToJson: true)
class MapSuggestResponse {
  const MapSuggestResponse({this.items = const []});

  factory MapSuggestResponse.fromJson(Map<String, dynamic> json) =>
      _$MapSuggestResponseFromJson(json);

  final List<MapSuggestItem> items;

  Map<String, dynamic> toJson() => _$MapSuggestResponseToJson(this);
}
