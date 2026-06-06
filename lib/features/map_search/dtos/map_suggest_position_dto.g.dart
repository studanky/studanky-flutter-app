// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_suggest_position_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapSuggestPositionDto _$MapSuggestPositionDtoFromJson(
  Map<String, dynamic> json,
) => MapSuggestPositionDto(
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
);

Map<String, dynamic> _$MapSuggestPositionDtoToJson(
  MapSuggestPositionDto instance,
) => <String, dynamic>{'lat': instance.lat, 'lon': instance.lon};
