import 'package:json_annotation/json_annotation.dart';
import 'package:studanky_flutter_app/features/map_search/dtos/map_suggest_language_dto.dart';
import 'package:studanky_flutter_app/features/map_search/dtos/map_suggest_type_dto.dart';

part 'map_suggest_query_dto.g.dart';

@JsonSerializable(createFactory: false, explicitToJson: true)
class MapySuggestQueryDto {
  const MapySuggestQueryDto({
    required this.query,
    required this.language,
    required this.limit,
    required this.types,
    this.preferNear,
    this.preferNearPrecision,
  });

  /// User-entered text.
  final String query;

  /// Language of the suggestions.
  @JsonKey(name: 'lang')
  final MapSuggestLanguageDto language;

  /// Number of suggestions requested.
  final int limit;

  /// Mapy.cz expects `type=a,b,c` instead of an array.
  @JsonKey(name: 'type', toJson: _typesToCsv)
  final List<MapSuggestTypeDto> types;

  /// Soft location bias as `"{lon},{lat}"` (longitude first — Mapy.com's
  /// `preferNear`): ranks suggestions by proximity to where the user is
  /// looking, without hard-excluding matches elsewhere. Null → no bias.
  @JsonKey(name: 'preferNear', includeIfNull: false)
  final String? preferNear;

  /// Radius in metres of the [preferNear] preference circle (Mapy.com's
  /// `preferNearPrecision`). Null → let the API decide.
  @JsonKey(name: 'preferNearPrecision', includeIfNull: false)
  final int? preferNearPrecision;

  Map<String, dynamic> toJson() => _$MapySuggestQueryDtoToJson(this);

  Map<String, dynamic> toQueryParameters(String apiKey) {
    return <String, dynamic>{...toJson(), 'apikey': apiKey};
  }

  static String _typesToCsv(List<MapSuggestTypeDto> values) =>
      values.map((value) => value.toJson()).join(',');
}
