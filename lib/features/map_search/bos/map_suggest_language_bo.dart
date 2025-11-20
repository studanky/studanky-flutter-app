import 'package:json_annotation/json_annotation.dart';

part 'map_suggest_language_bo.g.dart';

@JsonEnum(alwaysCreate: true)
enum MapSuggestLanguageBO {
  @JsonValue('cs')
  czech,
  @JsonValue('en')
  english;

  factory MapSuggestLanguageBO.fromCode(String code) {
    return MapSuggestLanguageBO.values.firstWhere(
      (lang) => lang.toJson() == code,
      orElse: () => MapSuggestLanguageBO.czech,
    );
  }

  String toJson() => _$MapSuggestLanguageBOEnumMap[this]!;
}
