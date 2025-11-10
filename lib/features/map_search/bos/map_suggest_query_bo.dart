import 'package:json_annotation/json_annotation.dart';

part 'map_suggest_query_bo.g.dart';

@JsonSerializable(createFactory: false)
class MapySuggestQueryBO {
  const MapySuggestQueryBO({
    required this.query,
    required this.language,
    required this.limit,
    required this.types,
  });

  /// User-entered text.
  final String query;

  /// Expected localization returned by the API.
  @JsonKey(name: 'lang')
  final String language;

  /// Number of suggestions requested.
  final int limit;

  /// Mapy.cz expects `type=a,b,c` instead of an array.
  @JsonKey(name: 'type', toJson: _typesToCsv)
  final List<String> types;

  Map<String, dynamic> toJson() => _$MapySuggestQueryBOToJson(this);

  Map<String, dynamic> toQueryParameters(String apiKey) {
    return <String, dynamic>{...toJson(), 'apikey': apiKey};
  }

  static String _typesToCsv(List<String> values) => values.join(',');
}
