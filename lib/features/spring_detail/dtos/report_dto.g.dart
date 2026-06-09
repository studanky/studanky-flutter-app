// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportDto _$ReportDtoFromJson(Map<String, dynamic> json) => ReportDto(
  documentId: json['documentId'] as String,
  isFlowing: json['is_flowing'] as bool,
  reportedAt: DateTime.parse(json['reported_at'] as String),
  flowScale: (json['flow_scale'] as num?)?.toInt(),
  flowRateLps: (json['flow_rate_lps'] as num?)?.toDouble(),
  hasOdor: json['has_odor'] as bool?,
  waterClarity: json['water_clarity'] as String?,
  note: json['note'] as String?,
);

Map<String, dynamic> _$ReportDtoToJson(ReportDto instance) => <String, dynamic>{
  'documentId': instance.documentId,
  'is_flowing': instance.isFlowing,
  'flow_scale': instance.flowScale,
  'flow_rate_lps': instance.flowRateLps,
  'has_odor': instance.hasOdor,
  'water_clarity': instance.waterClarity,
  'note': instance.note,
  'reported_at': instance.reportedAt.toIso8601String(),
};
