import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/water_clarity.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/formatters/water_clarity_label.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/detail_section.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/metric_scale_value.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/segment_scale.dart';
import 'package:studanky_flutter_app/features/springs/presentation/formatters/spring_formatters.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Latest known flow strength, discharge and clarity metrics.
class CurrentStateSection extends StatelessWidget {
  const CurrentStateSection({
    super.key,
    required this.statusIcon,
    required this.flowScale,
    required this.flowRateLps,
    required this.clarity,
    required this.maxFlowScale,
  });

  final SpringIcon statusIcon;
  final int? flowScale;
  final double? flowRateLps;
  final WaterClarity? clarity;
  final int maxFlowScale;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final text = context.appTextStyles;
    final isStale = statusIcon == SpringIcon.stale;
    final scaleColor = isStale ? colors.statusStale : null;
    final valueColor = isStale ? colors.neutral700 : colors.neutral900;

    final rows = <Widget>[
      if (flowScale != null)
        DetailMetricRow(
          padding: EdgeInsets.zero,
          label: l10n.spring_detail_report_flow_strength,
          value: MetricScaleValue(
            scale: SegmentScale(
              value: flowScale!,
              max: maxFlowScale,
              color: scaleColor,
            ),
            label: '$flowScale/$maxFlowScale',
            labelColor: valueColor,
          ),
        ),
      if (flowRateLps != null)
        DetailMetricRow(
          padding: EdgeInsets.zero,
          label: l10n.spring_detail_report_flow_rate,
          value: Text(
            l10n.spring_detail_flow_rate_value(
              SpringFormatters.flowRate(flowRateLps!),
            ),
            style: text.title2.copyWith(color: valueColor),
          ),
        ),
      if (clarity != null)
        DetailMetricRow(
          padding: EdgeInsets.zero,
          label: l10n.spring_detail_report_clarity,
          value: MetricScaleValue(
            scale: SegmentScale(
              value: clarity!.clarityLevel,
              max: WaterClarity.maxLevel,
              color: scaleColor,
            ),
            label: waterClarityLabel(clarity!, l10n),
            labelColor: valueColor,
          ),
        ),
    ];

    if (rows.isEmpty) return const SizedBox.shrink();

    return DetailSection(
      title: isStale
          ? l10n.spring_detail_section_last_known
          : l10n.spring_detail_section_current,
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++) ...[
            if (index > 0) const SizedBox(height: 14),
            rows[index],
          ],
        ],
      ),
    );
  }
}
