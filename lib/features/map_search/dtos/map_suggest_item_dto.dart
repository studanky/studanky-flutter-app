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
    this.bbox,
  });

  factory MapSuggestItemDto.fromJson(Map<String, dynamic> json) =>
      _$MapSuggestItemDtoFromJson(json);

  final String name;
  final MapSuggestPositionDto position;
  final MapSuggestTypeDto type;

  /// Bounding box of the locality as `[minLon, minLat, maxLon, maxLat]`, when
  /// the suggest API provides one. Lets the client fit the whole place in view.
  final List<double>? bbox;

  Map<String, dynamic> toJson() => _$MapSuggestItemDtoToJson(this);
}
