import 'package:json_annotation/json_annotation.dart';
import 'package:studanky_flutter_app/features/map_search/dtos/map_suggest_position_dto.dart';
import 'package:studanky_flutter_app/features/map_search/dtos/map_suggest_type_dto.dart';

part 'map_suggest_item_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class MapSuggestItemDto {
  const MapSuggestItemDto({
    required this.name,
    required this.position,
    required this.type,
  });

  factory MapSuggestItemDto.fromJson(Map<String, dynamic> json) =>
      _$MapSuggestItemDtoFromJson(json);

  final String name;
  final MapSuggestPositionDto position;
  final MapSuggestTypeDto type;

  Map<String, dynamic> toJson() => _$MapSuggestItemDtoToJson(this);
}
