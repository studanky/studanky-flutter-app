// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_spring_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteSpringDto _$FavoriteSpringDtoFromJson(Map<String, dynamic> json) =>
    FavoriteSpringDto(
      documentId: json['documentId'] as String,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      status: json['status'] as String,
      statusUpdatedAt: json['statusUpdatedAt'] == null
          ? null
          : DateTime.parse(json['statusUpdatedAt'] as String),
    );

Map<String, dynamic> _$FavoriteSpringDtoToJson(FavoriteSpringDto instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'name': instance.name,
      'lat': instance.lat,
      'lng': instance.lng,
      'status': instance.status,
      'statusUpdatedAt': instance.statusUpdatedAt?.toIso8601String(),
    };
