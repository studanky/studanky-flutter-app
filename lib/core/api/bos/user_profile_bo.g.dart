// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_bo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileBO _$UserProfileBOFromJson(Map<String, dynamic> json) =>
    UserProfileBO(
      id: (json['id'] as num).toInt(),
      documentId: json['documentId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      cowshedDocumentIds: (json['cowshedDocumentIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserProfileBOToJson(UserProfileBO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentId': instance.documentId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'cowshedDocumentIds': instance.cowshedDocumentIds,
    };
