import 'package:json_annotation/json_annotation.dart';

part 'report_dto.g.dart';

/// One item of `GET /api/springs/:documentId/reports` — the public field
/// allowlist (api-reference.md §3.3). Private fields (`user_lat`, `device_id`,
/// …) are never exposed by the API and intentionally absent here.
@JsonSerializable()
class ReportDto {
  const ReportDto({
    required this.documentId,
    required this.isFlowing,
    required this.reportedAt,
    this.flowScale,
    this.flowRateLps,
    this.hasOdor,
    this.waterClarity,
    this.note,
  });

  factory ReportDto.fromJson(Map<String, dynamic> json) =>
      _$ReportDtoFromJson(json);

  final String documentId;

  @JsonKey(name: 'is_flowing')
  final bool isFlowing;

  @JsonKey(name: 'flow_scale')
  final int? flowScale;

  @JsonKey(name: 'flow_rate_lps')
  final double? flowRateLps;

  @JsonKey(name: 'has_odor')
  final bool? hasOdor;

  @JsonKey(name: 'water_clarity')
  final String? waterClarity;

  final String? note;

  @JsonKey(name: 'reported_at')
  final DateTime reportedAt;

  Map<String, dynamic> toJson() => _$ReportDtoToJson(this);
}
