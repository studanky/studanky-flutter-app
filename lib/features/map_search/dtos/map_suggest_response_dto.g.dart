// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_suggest_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapSuggestResponseDto _$MapSuggestResponseDtoFromJson(
  Map<String, dynamic> json,
) => MapSuggestResponseDto(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => MapSuggestItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$MapSuggestResponseDtoToJson(
  MapSuggestResponseDto instance,
) => <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
