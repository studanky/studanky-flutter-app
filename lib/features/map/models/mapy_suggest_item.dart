import 'package:json_annotation/json_annotation.dart';
import 'package:studanky_flutter_app/features/map/models/mapy_suggest_position.dart';

part 'mapy_suggest_item.g.dart';

@JsonSerializable(explicitToJson: true)
class MapySuggestItem {
  const MapySuggestItem({this.id, this.name, this.description, this.position});

  factory MapySuggestItem.fromJson(Map<String, dynamic> json) =>
      _$MapySuggestItemFromJson(json);

  final String? id;
  final String? name;
  final String? description;
  final MapySuggestPosition? position;

  Map<String, dynamic> toJson() => _$MapySuggestItemToJson(this);
}
