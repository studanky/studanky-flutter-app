// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_suggest_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapSuggestResponse _$MapSuggestResponseFromJson(Map<String, dynamic> json) =>
    MapSuggestResponse(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => MapSuggestItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MapSuggestResponseToJson(MapSuggestResponse instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
