import 'package:json_annotation/json_annotation.dart';
import 'package:studanky_flutter_app/features/map_search/bos/map_suggest_language_bo.dart';
import 'package:studanky_flutter_app/features/map_search/bos/map_suggest_type_bo.dart';

part 'map_suggest_query_bo.g.dart';

@JsonSerializable(createFactory: false, explicitToJson: true)
class MapySuggestQueryBO {
  const MapySuggestQueryBO({
    required this.query,
    required this.language,
    required this.limit,
    required this.types,
  });

  /// User-entered text.
  final String query;

  /// Language of the suggestions.
  @JsonKey(name: 'lang')
  final MapSuggestLanguageBO language;

  /// Number of suggestions requested.
  final int limit;

  /// Mapy.cz expects `type=a,b,c` instead of an array.
  @JsonKey(name: 'type', toJson: _typesToCsv)
  final List<MapSuggestTypeBO> types;

  Map<String, dynamic> toJson() => _$MapySuggestQueryBOToJson(this);

  Map<String, dynamic> toQueryParameters(String apiKey) {
    return <String, dynamic>{...toJson(), 'apikey': apiKey};
  }

  static String _typesToCsv(List<MapSuggestTypeBO> values) =>
      values.map((value) => value.toJson()).join(',');
}
