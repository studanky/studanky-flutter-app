import 'package:json_annotation/json_annotation.dart';
import 'package:studanky_flutter_app/features/map_page/models/map_suggest_position.dart';

part 'map_suggest_item.g.dart';

@JsonSerializable(explicitToJson: true)
class MapSuggestItem {
  const MapSuggestItem({this.id, this.name, this.description, this.position});

  factory MapSuggestItem.fromJson(Map<String, dynamic> json) =>
      _$MapSuggestItemFromJson(json);

  final String? id;
  final String? name;
  final String? description;
  final MapSuggestPosition? position;

  Map<String, dynamic> toJson() => _$MapSuggestItemToJson(this);
}
