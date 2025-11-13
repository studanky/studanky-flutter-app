import 'package:json_annotation/json_annotation.dart';
import 'package:studanky_flutter_app/features/map_search/bos/map_suggest_item_bo.dart';

part 'map_suggest_response_bo.g.dart';

@JsonSerializable(explicitToJson: true)
class MapSuggestResponseBO {
  const MapSuggestResponseBO({this.items = const []});

  factory MapSuggestResponseBO.fromJson(Map<String, dynamic> json) =>
      _$MapSuggestResponseBOFromJson(json);

  final List<MapSuggestItemBO> items;

  Map<String, dynamic> toJson() => _$MapSuggestResponseBOToJson(this);
}
