import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/haptics/haptics.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/report.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/water_clarity.dart';
import 'package:studanky_flutter_app/features/spring_detail/utils/spring_formatters.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/detail_section.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/segment_scale.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/status_visuals.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// One expandable record in the history list: a compact status + date header
/// with a "verified · ČHMÚ" provenance badge (X/Meta style), opening to reveal
/// the record's measured and subjective detail — flow strength and clarity
/// shown graphically — only for the parameters it actually carries (zadání §14,
/// §17).
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

  void _toggle() {
    Haptics.selection();
    setState(() => _expanded = !_expanded);
  }

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
                  // Provenance badge — a verified check + source name, the way
                  // X / Meta mark a verified account.
                  if (report.isStationMeasurement)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: colors.primaryMain,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.spring_detail_station_record,
                            style: text.body2.copyWith(
                              fontSize: 12.5,
                              color: colors.neutral700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (canExpand)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 180),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: colors.neutral500,
                        ),
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

/// Expanded detail: each parameter as a label-left / value-right row separated
/// by iOS-style inset dividers, indented under the record's status text.
class _ReportDetails extends StatelessWidget {
  const _ReportDetails({required this.report, required this.maxFlowScale});

  final Report report;
  final int maxFlowScale;

  /// Left inset that lines the rows up under the status label above.
  static const double _indent = 46;
  static const EdgeInsets _rowPadding = EdgeInsets.fromLTRB(_indent, 0, 16, 0);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final clarity = report.waterClarity;
    final odor = report.hasOdor;
    final valueStyle = text.title2.copyWith(color: colors.neutral900);

    final rows = <Widget>[
      if (report.flowScale != null)
        DetailMetricRow(
          padding: _rowPadding,
          label: l10n.spring_detail_report_flow_strength,
          value: _ScaleValue(
            value: report.flowScale!,
            max: maxFlowScale,
            label: '${report.flowScale}/$maxFlowScale',
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
          value: _ScaleValue(
            value: clarity.clarityLevel,
            max: WaterClarity.maxLevel,
            label: waterClarityLabel(clarity, l10n),
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
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            rows[i],
          ],
        ],
      ),
    );
  }
}

/// A small flow/clarity scale with its trailing number/word label, used as a
/// right-aligned row value.
class _ScaleValue extends StatelessWidget {
  const _ScaleValue({
    required this.value,
    required this.max,
    required this.label,
  });

  final int value;
  final int max;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SegmentScale(value: value, max: max),
        const SizedBox(width: 8),
        Text(label, style: text.title2.copyWith(color: colors.neutral900)),
      ],
    );
  }
}
