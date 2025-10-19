// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_suggest_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapSuggestItem _$MapSuggestItemFromJson(Map<String, dynamic> json) =>
    MapSuggestItem(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      position: json['position'] == null
          ? null
          : MapSuggestPosition.fromJson(
              json['position'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$MapSuggestItemToJson(MapSuggestItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'position': instance.position?.toJson(),
    };
