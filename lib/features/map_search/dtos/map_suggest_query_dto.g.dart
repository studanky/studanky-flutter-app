// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_suggest_query_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$MapySuggestQueryDtoToJson(
  MapySuggestQueryDto instance,
) => <String, dynamic>{
  'query': instance.query,
  'lang': instance.language.toJson(),
  'limit': instance.limit,
  'type': MapySuggestQueryDto._typesToCsv(instance.types),
  'preferNear': ?instance.preferNear,
  'preferNearPrecision': ?instance.preferNearPrecision,
};
