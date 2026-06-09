// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spring_owner_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpringOwnerDto _$SpringOwnerDtoFromJson(Map<String, dynamic> json) =>
    SpringOwnerDto(
      name: json['name'] as String,
      documentId: json['documentId'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$SpringOwnerDtoToJson(SpringOwnerDto instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'name': instance.name,
      'type': instance.type,
    };
