// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_suggest_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapSuggestItemDto _$MapSuggestItemDtoFromJson(Map<String, dynamic> json) =>
    MapSuggestItemDto(
      name: json['name'] as String,
      position: MapSuggestPositionDto.fromJson(
        json['position'] as Map<String, dynamic>,
      ),
      type: $enumDecode(_$MapSuggestTypeDtoEnumMap, json['type']),
      location: json['location'] as String?,
      bbox: (json['bbox'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$MapSuggestItemDtoToJson(MapSuggestItemDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'position': instance.position.toJson(),
      'type': instance.type.toJson(),
      'location': instance.location,
      'bbox': instance.bbox,
    };

const _$MapSuggestTypeDtoEnumMap = {
  MapSuggestTypeDto.regional: 'regional',
  MapSuggestTypeDto.regionalCountry: 'regional.country',
  MapSuggestTypeDto.regionalRegion: 'regional.region',
  MapSuggestTypeDto.regionalMunicipality: 'regional.municipality',
  MapSuggestTypeDto.regionalMunicipalityPart: 'regional.municipality_part',
  MapSuggestTypeDto.regionalStreet: 'regional.street',
  MapSuggestTypeDto.regionalAddress: 'regional.address',
  MapSuggestTypeDto.poi: 'poi',
  MapSuggestTypeDto.coordinate: 'coordinate',
};
