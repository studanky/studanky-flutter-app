import 'package:json_annotation/json_annotation.dart';
import 'package:studanky_flutter_app/features/map_search/bos/map_suggest_item_type_bo.dart';
import 'package:studanky_flutter_app/features/map_search/bos/map_suggest_position_bo.dart';

part 'map_suggest_item_bo.g.dart';

@JsonSerializable(explicitToJson: true)
class MapSuggestItemBO {
  const MapSuggestItemBO({
    required this.name,
    required this.position,
    required this.type,
  });

  factory MapSuggestItemBO.fromJson(Map<String, dynamic> json) =>
      _$MapSuggestItemBOFromJson(json);

  final String name;
  final MapSuggestPositionBO position;
  final MapSuggestItemTypeBo type;

  Map<String, dynamic> toJson() => _$MapSuggestItemBOToJson(this);
}
