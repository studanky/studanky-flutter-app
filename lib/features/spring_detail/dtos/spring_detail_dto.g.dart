// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spring_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpringDetailDto _$SpringDetailDtoFromJson(Map<String, dynamic> json) =>
    SpringDetailDto(
      documentId: json['documentId'] as String,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      currentStatus: json['current_status'] as String,
      description: json['description'] as String?,
      statusUpdatedAt: json['status_updated_at'] == null
          ? null
          : DateTime.parse(json['status_updated_at'] as String),
      lastFlowScale: (json['last_flow_scale'] as num?)?.toInt(),
      lastFlowRateLps: (json['last_flow_rate_lps'] as num?)?.toDouble(),
      photo: json['photo'] == null
          ? null
          : SpringMediaDto.fromJson(json['photo'] as Map<String, dynamic>),
      owner: json['owner'] == null
          ? null
          : SpringOwnerDto.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SpringDetailDtoToJson(SpringDetailDto instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'name': instance.name,
      'description': instance.description,
      'lat': instance.lat,
      'lng': instance.lng,
      'current_status': instance.currentStatus,
      'status_updated_at': instance.statusUpdatedAt?.toIso8601String(),
      'last_flow_scale': instance.lastFlowScale,
      'last_flow_rate_lps': instance.lastFlowRateLps,
      'photo': instance.photo?.toJson(),
      'owner': instance.owner?.toJson(),
    };
