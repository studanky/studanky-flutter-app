import 'package:json_annotation/json_annotation.dart';
import 'package:studanky_flutter_app/features/platform_config/dtos/flow_range_dto.dart';

part 'platform_config_dto.g.dart';

/// Platform config single type (`api::platform-config.platform-config`).
///
/// Exact mirror of the API payload (see api-reference.md §2.3 / §3.4). The
/// `flow_scale_ranges` component is only present when explicitly populated via
/// `populate[flow_scale_ranges]=true`; absent populate yields an empty list.
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PlatformConfigDto {
  const PlatformConfigDto({
    required this.freshnessThresholdDays,
    this.flowScaleRanges = const <FlowRangeDto>[],
  });

  factory PlatformConfigDto.fromJson(Map<String, dynamic> json) =>
      _$PlatformConfigDtoFromJson(json);

  final int freshnessThresholdDays;

  final List<FlowRangeDto> flowScaleRanges;

  Map<String, dynamic> toJson() => _$PlatformConfigDtoToJson(this);
}
