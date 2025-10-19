import 'package:json_annotation/json_annotation.dart';
import 'package:studanky_flutter_app/features/map/models/mapy_suggest_item.dart';

part 'mapy_suggest_response.g.dart';

@JsonSerializable(explicitToJson: true)
class MapySuggestResponse {
  const MapySuggestResponse({this.items = const []});

  factory MapySuggestResponse.fromJson(Map<String, dynamic> json) =>
      _$MapySuggestResponseFromJson(json);

  final List<MapySuggestItem> items;

  Map<String, dynamic> toJson() => _$MapySuggestResponseToJson(this);
}
