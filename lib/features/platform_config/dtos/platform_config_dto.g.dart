// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlatformConfigDto _$PlatformConfigDtoFromJson(Map<String, dynamic> json) =>
    PlatformConfigDto(
      freshnessThresholdDays: (json['freshness_threshold_days'] as num).toInt(),
      flowScaleRanges:
          (json['flow_scale_ranges'] as List<dynamic>?)
              ?.map((e) => FlowRangeDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FlowRangeDto>[],
    );

Map<String, dynamic> _$PlatformConfigDtoToJson(
  PlatformConfigDto instance,
) => <String, dynamic>{
  'freshness_threshold_days': instance.freshnessThresholdDays,
  'flow_scale_ranges': instance.flowScaleRanges.map((e) => e.toJson()).toList(),
};
