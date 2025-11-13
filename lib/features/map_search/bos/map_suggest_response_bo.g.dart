// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_suggest_response_bo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapSuggestResponseBO _$MapSuggestResponseBOFromJson(
  Map<String, dynamic> json,
) => MapSuggestResponseBO(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => MapSuggestItemBO.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$MapSuggestResponseBOToJson(
  MapSuggestResponseBO instance,
) => <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
