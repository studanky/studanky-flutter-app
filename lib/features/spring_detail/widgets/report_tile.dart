import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/report.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/water_clarity.dart';
import 'package:studanky_flutter_app/features/spring_detail/utils/spring_formatters.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/segment_scale.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/status_visuals.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// One expandable record in the history list: a compact status + date header
/// with an at-a-glance flow-strength bar, opening to reveal the report's
/// measured and subjective detail (flow strength, rate, clarity, odour, note) —
/// only the parameters the record actually carries (zadání §14, §17).
class ReportTile extends StatefulWidget {
  const ReportTile({
    required this.report,
    required this.maxFlowScale,
    this.initiallyExpanded = false,
    super.key,
  });

  final Report report;
  final int maxFlowScale;
  final bool initiallyExpanded;

  @override
  State<ReportTile> createState() => _ReportTileState();
}

class _ReportTileState extends State<ReportTile> {
  late bool _expanded = widget.initiallyExpanded;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final report = widget.report;
    final status = reportStatusVisual(report.isFlowing, colors, l10n);
    final canExpand = report.hasDetails;

    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: canExpand ? _toggle : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(status.icon, color: status.color, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          status.label,
                          style: text.title2.copyWith(color: colors.neutral900),
                        ),
                        Text(
                          SpringFormatters.shortDate(report.reportedAt),
                          style: text.body2.copyWith(color: colors.neutral700),
                        ),
                      ],
                    ),
                  ),
                  if (report.flowScale != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: SegmentScale(
                        value: report.flowScale!,
                        max: widget.maxFlowScale,
                        segmentWidth: 10,
                        height: 6,
                        gap: 3,
                      ),
                    ),
                  if (report.isStationMeasurement)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: colors.primaryMain,
                      ),
                    ),
                  if (canExpand)
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: colors.neutral500,
                      ),
                    ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _ReportDetails(
              report: report,
              maxFlowScale: widget.maxFlowScale,
            ),
            crossFadeState: _expanded && canExpand
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
            sizeCurve: Curves.easeOut,
          ),
        ],
      ),
    );
  }
}

class _ReportDetails extends StatelessWidget {
  const _ReportDetails({required this.report, required this.maxFlowScale});

  final Report report;
  final int maxFlowScale;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final clarity = report.waterClarity;
    final odor = report.hasOdor;
    final scaleLabel = text.title2.copyWith(color: colors.neutral900);

    return Padding(
      padding: const EdgeInsets.fromLTRB(46, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (report.flowScale != null)
            _DetailRow(
              label: l10n.spring_detail_report_flow_strength,
              value: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SegmentScale(value: report.flowScale!, max: maxFlowScale),
                  const SizedBox(width: 8),
                  Text('${report.flowScale}/$maxFlowScale', style: scaleLabel),
                ],
              ),
            ),
          if (report.flowRateLps != null)
            _DetailRow(
              label: l10n.spring_detail_report_flow_rate,
              value: Text(
                l10n.spring_detail_flow_rate_value(
                  SpringFormatters.flowRate(report.flowRateLps!),
                ),
                style: scaleLabel,
              ),
            ),
          if (clarity != null)
            _DetailRow(
              label: l10n.spring_detail_report_clarity,
              value: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SegmentScale(
                    value: clarity.clarityLevel,
                    max: WaterClarity.maxLevel,
                  ),
                  const SizedBox(width: 8),
                  Text(waterClarityLabel(clarity, l10n), style: scaleLabel),
                ],
              ),
            ),
          if (odor != null)
            _DetailRow(
              label: l10n.spring_detail_report_odor,
              value: Text(
                odor ? l10n.common_yes : l10n.common_no,
                style: scaleLabel,
              ),
            ),
          if (report.hasNote)
            _DetailRow(
              label: l10n.spring_detail_report_note,
              value: Text(
                report.note!,
                style: text.body2.copyWith(color: colors.neutral800),
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                label,
                style: text.body2.copyWith(color: colors.neutral700),
              ),
            ),
          ),
          Expanded(child: value),
        ],
      ),
    );
  }
}
