import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/report.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/water_clarity.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/formatters/water_clarity_label.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/detail_section.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/metric_scale_value.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/segment_scale.dart';
import 'package:studanky_flutter_app/features/springs/presentation/formatters/spring_formatters.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Expanded measurement rows for a history report.
class ReportDetails extends StatelessWidget {
  const ReportDetails({
    super.key,
    required this.report,
    required this.maxFlowScale,
  });

  final Report report;
  final int maxFlowScale;

  static const double _indent = 46;
  static const EdgeInsets _rowPadding = EdgeInsets.fromLTRB(_indent, 0, 16, 0);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final text = context.appTextStyles;
    final clarity = report.waterClarity;
    final odor = report.hasOdor;
    final valueStyle = text.title2.copyWith(color: colors.neutral900);

    final rows = <Widget>[
      if (report.flowScale != null)
        DetailMetricRow(
          padding: _rowPadding,
          label: l10n.spring_detail_report_flow_strength,
          value: MetricScaleValue(
            scale: SegmentScale(value: report.flowScale!, max: maxFlowScale),
            label: '${report.flowScale}/$maxFlowScale',
            labelColor: colors.neutral900,
            spacing: 8,
          ),
        ),
      if (report.flowRateLps != null)
        DetailMetricRow(
          padding: _rowPadding,
          label: l10n.spring_detail_report_flow_rate,
          value: Text(
            l10n.spring_detail_flow_rate_value(
              SpringFormatters.flowRate(report.flowRateLps!),
            ),
            style: valueStyle,
          ),
        ),
      if (clarity != null)
        DetailMetricRow(
          padding: _rowPadding,
          label: l10n.spring_detail_report_clarity,
          value: MetricScaleValue(
            scale: SegmentScale(
              value: clarity.clarityLevel,
              max: WaterClarity.maxLevel,
            ),
            label: waterClarityLabel(clarity, l10n),
            labelColor: colors.neutral900,
            spacing: 8,
          ),
        ),
      if (odor != null)
        DetailMetricRow(
          padding: _rowPadding,
          label: l10n.spring_detail_report_odor,
          value: Text(
            odor ? l10n.common_yes : l10n.common_no,
            style: valueStyle,
          ),
        ),
      if (report.hasNote)
        DetailMetricRow(
          padding: _rowPadding,
          label: l10n.spring_detail_report_note,
          value: Text(
            report.note!,
            textAlign: TextAlign.right,
            style: text.body2.copyWith(color: colors.neutral800),
          ),
        ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++) ...[
            if (index > 0) const SizedBox(height: 10),
            rows[index],
          ],
        ],
      ),
    );
  }
}
