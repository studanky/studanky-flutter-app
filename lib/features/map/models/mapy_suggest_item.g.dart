// GENERATED CODE - MANUALLY MAINTAINED

part of 'mapy_suggest_item.dart';

MapySuggestItem _$MapySuggestItemFromJson(Map<String, dynamic> json) =>
    MapySuggestItem(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      position: json['position'] == null
          ? null
          : MapySuggestPosition.fromJson(
              json['position'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MapySuggestItemToJson(MapySuggestItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'position': instance.position?.toJson(),
    };
