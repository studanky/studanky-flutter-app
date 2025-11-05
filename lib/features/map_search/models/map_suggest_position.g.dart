// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_suggest_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapSuggestPosition _$MapSuggestPositionFromJson(Map<String, dynamic> json) =>
    MapSuggestPosition(
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MapSuggestPositionToJson(MapSuggestPosition instance) =>
    <String, dynamic>{'lat': instance.lat, 'lon': instance.lon};
