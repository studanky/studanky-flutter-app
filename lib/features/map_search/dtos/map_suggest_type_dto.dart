import 'package:json_annotation/json_annotation.dart';

part 'map_suggest_type_dto.g.dart';

@JsonEnum(alwaysCreate: true)
enum MapSuggestTypeDto {
  @JsonValue('regional')
  regional,
  @JsonValue('regional.country')
  regionalCountry,
  @JsonValue('regional.region')
  regionalRegion,
  @JsonValue('regional.municipality')
  regionalMunicipality,
  @JsonValue('regional.municipality_part')
  regionalMunicipalityPart,
  @JsonValue('regional.street')
  regionalStreet,
  @JsonValue('regional.address')
  regionalAddress,
  @JsonValue('poi')
  poi,
  @JsonValue('coordinate')
  coordinate;

  String toJson() => _$MapSuggestTypeDtoEnumMap[this]!;
}
