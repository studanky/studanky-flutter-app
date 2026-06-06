// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExampleItemDto _$ExampleItemDtoFromJson(Map<String, dynamic> json) =>
    ExampleItemDto(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ExampleItemDtoToJson(ExampleItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
    };
