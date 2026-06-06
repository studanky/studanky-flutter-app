import 'package:json_annotation/json_annotation.dart';

part 'flow_range_dto.g.dart';

/// One row of the `flow_scale_ranges` component on the platform config single
/// type — maps a measured discharge band (l/s) onto the shared 1–5 scale.
///
/// Exact mirror of the API payload (see api-reference.md §2.3). The endpoint
/// uses snake_case keys, so [JsonSerializable.fieldRename] is set accordingly.
@JsonSerializable(fieldRename: FieldRename.snake)
class FlowRangeDto {
  const FlowRangeDto({
    required this.scale,
    required this.minLps,
    required this.maxLps,
  });

  factory FlowRangeDto.fromJson(Map<String, dynamic> json) =>
      _$FlowRangeDtoFromJson(json);

  final int scale;
  final double minLps;
  final double maxLps;

  Map<String, dynamic> toJson() => _$FlowRangeDtoToJson(this);
}
