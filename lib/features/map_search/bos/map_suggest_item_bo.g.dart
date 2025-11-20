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
      type: $enumDecode(_$MapSuggestTypeBOEnumMap, json['type']),
    );

Map<String, dynamic> _$MapSuggestItemBOToJson(MapSuggestItemBO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'position': instance.position.toJson(),
      'type': instance.type.toJson(),
    };

const _$MapSuggestTypeBOEnumMap = {
  MapSuggestTypeBO.regional: 'regional',
  MapSuggestTypeBO.regionalCountry: 'regional.country',
  MapSuggestTypeBO.regionalRegion: 'regional.region',
  MapSuggestTypeBO.regionalMunicipality: 'regional.municipality',
  MapSuggestTypeBO.regionalMunicipalityPart: 'regional.municipality_part',
  MapSuggestTypeBO.regionalStreet: 'regional.street',
  MapSuggestTypeBO.regionalAddress: 'regional.address',
  MapSuggestTypeBO.poi: 'poi',
  MapSuggestTypeBO.coordinate: 'coordinate',
};
