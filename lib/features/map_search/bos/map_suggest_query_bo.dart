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
  @JsonKey(name: 'lang', toJson: _languageToCode)
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

  static String _languageToCode(MapSuggestLanguageBO language) => language.code;
  static String _typesToCsv(List<MapSuggestTypeBO> values) =>
      values.map((type) => type.code).join(',');
}

enum MapSuggestLanguageBO {
  czech('cs'),
  english('en');

  const MapSuggestLanguageBO(this.code);

  final String code;
}

enum MapSuggestTypeBO {
  regional('regional'),
  regionalCountry('regional.country'),
  regionalRegion('regional.region'),
  regionalMunicipality('regional.municipality'),
  regionalMunicipalityPart('regional.municipality_part'),
  regionalStreet('regional.street'),
  regionalAddress('regional.address'),
  poi('poi'),
  coordinate('coordinate');

  const MapSuggestTypeBO(this.code);

  final String code;
}
