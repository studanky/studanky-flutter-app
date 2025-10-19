// GENERATED CODE - MANUALLY MAINTAINED

part of 'mapy_suggest_response.dart';

MapySuggestResponse _$MapySuggestResponseFromJson(
        Map<String, dynamic> json) =>
    MapySuggestResponse(
      items: (json['items'] as List<dynamic>?)
              ?.map(
                (e) => MapySuggestItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MapySuggestResponseToJson(
        MapySuggestResponse instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
