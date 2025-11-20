// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_suggest_item_bo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapSuggestItemBO _$MapSuggestItemBOFromJson(Map<String, dynamic> json) =>
    MapSuggestItemBO(
      name: json['name'] as String,
      position: MapSuggestPositionBO.fromJson(
        json['position'] as Map<String, dynamic>,
      ),
      type: $enumDecode(_$MapSuggestItemTypeBoEnumMap, json['type']),
    );

Map<String, dynamic> _$MapSuggestItemBOToJson(MapSuggestItemBO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'position': instance.position.toJson(),
      'type': _$MapSuggestItemTypeBoEnumMap[instance.type]!,
    };

const _$MapSuggestItemTypeBoEnumMap = {
  MapSuggestItemTypeBo.regional: 'regional',
  MapSuggestItemTypeBo.regionalCountry: 'regional.country',
  MapSuggestItemTypeBo.regionalRegion: 'regional.region',
  MapSuggestItemTypeBo.regionalMunicipality: 'regional.municipality',
  MapSuggestItemTypeBo.regionalMunicipalityPart: 'regional.municipality_part',
  MapSuggestItemTypeBo.regionalStreet: 'regional.street',
  MapSuggestItemTypeBo.regionalAddress: 'regional.address',
  MapSuggestItemTypeBo.poi: 'poi',
  MapSuggestItemTypeBo.coordinate: 'coordinate',
};
