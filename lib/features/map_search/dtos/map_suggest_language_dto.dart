import 'package:json_annotation/json_annotation.dart';

part 'map_suggest_language_dto.g.dart';

@JsonEnum(alwaysCreate: true)
enum MapSuggestLanguageDto {
  @JsonValue('cs')
  czech,
  @JsonValue('en')
  english;

  factory MapSuggestLanguageDto.fromCode(String code) {
    return MapSuggestLanguageDto.values.firstWhere(
      (lang) => lang.toJson() == code,
      orElse: () => MapSuggestLanguageDto.czech,
    );
  }

  String toJson() => _$MapSuggestLanguageDtoEnumMap[this]!;
}
