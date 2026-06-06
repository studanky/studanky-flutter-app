// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flow_range_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlowRangeDto _$FlowRangeDtoFromJson(Map<String, dynamic> json) => FlowRangeDto(
  scale: (json['scale'] as num).toInt(),
  minLps: (json['min_lps'] as num).toDouble(),
  maxLps: (json['max_lps'] as num).toDouble(),
);

Map<String, dynamic> _$FlowRangeDtoToJson(FlowRangeDto instance) =>
    <String, dynamic>{
      'scale': instance.scale,
      'min_lps': instance.minLps,
      'max_lps': instance.maxLps,
    };
