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
    );

Map<String, dynamic> _$MapSuggestItemBOToJson(MapSuggestItemBO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'position': instance.position.toJson(),
    };
