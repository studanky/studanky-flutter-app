// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_item_bo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExampleItemBO _$ExampleItemBOFromJson(Map<String, dynamic> json) =>
    ExampleItemBO(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ExampleItemBOToJson(ExampleItemBO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
    };
