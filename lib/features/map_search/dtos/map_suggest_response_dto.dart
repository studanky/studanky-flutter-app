import 'package:json_annotation/json_annotation.dart';
import 'package:studanky_flutter_app/features/map_search/dtos/map_suggest_item_dto.dart';

part 'map_suggest_response_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class MapSuggestResponseDto {
  const MapSuggestResponseDto({this.items = const []});

  factory MapSuggestResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MapSuggestResponseDtoFromJson(json);

  final List<MapSuggestItemDto> items;

  Map<String, dynamic> toJson() => _$MapSuggestResponseDtoToJson(this);
}
