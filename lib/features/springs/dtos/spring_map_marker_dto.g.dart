// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spring_map_marker_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpringMapMarkerDto _$SpringMapMarkerDtoFromJson(Map<String, dynamic> json) =>
    SpringMapMarkerDto(
      documentId: json['documentId'] as String,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      currentStatus: json['current_status'] as String,
      statusUpdatedAt: json['status_updated_at'] == null
          ? null
          : DateTime.parse(json['status_updated_at'] as String),
      distanceMeters: (json['distance_m'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SpringMapMarkerDtoToJson(SpringMapMarkerDto instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'name': instance.name,
      'lat': instance.lat,
      'lng': instance.lng,
      'current_status': instance.currentStatus,
      'status_updated_at': instance.statusUpdatedAt?.toIso8601String(),
      'distance_m': instance.distanceMeters,
    };
