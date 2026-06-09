import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/report.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/water_clarity.dart';
import 'package:studanky_flutter_app/features/spring_detail/utils/spring_formatters.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/status_visuals.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// One expandable record in the history list: a compact status + date header
/// that opens to reveal the report's measured and subjective detail.
class ReportTile extends StatefulWidget {
  const ReportTile({
    required this.report,
    this.initiallyExpanded = false,
    super.key,
  });

  final Report report;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: canExpand ? _toggle : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
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
                if (report.isStationMeasurement)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _StationTag(label: l10n.spring_detail_station_record),
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
          secondChild: _ReportDetails(report: report),
          crossFadeState: _expanded && canExpand
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 180),
          sizeCurve: Curves.easeOut,
        ),
      ],
    );
  }
}

class _ReportDetails extends StatelessWidget {
  const _ReportDetails({required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final clarity = report.waterClarity;
    final odor = report.hasOdor;

    return Padding(
      padding: const EdgeInsets.only(left: 30, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (report.flowScale != null)
            _DetailRow(
              label: l10n.spring_detail_report_flow_strength,
              value: l10n.spring_detail_flow_strength_value(report.flowScale!),
            ),
          if (report.flowRateLps != null)
            _DetailRow(
              label: l10n.spring_detail_report_flow_rate,
              value: l10n.spring_detail_flow_rate_value(
                SpringFormatters.flowRate(report.flowRateLps!),
              ),
            ),
          if (clarity != null)
            _DetailRow(
              label: l10n.spring_detail_report_clarity,
              value: _clarityLabel(clarity, l10n),
            ),
          if (odor != null)
            _DetailRow(
              label: l10n.spring_detail_report_odor,
              value: odor ? l10n.common_yes : l10n.common_no,
            ),
          if (report.hasNote)
            _DetailRow(
              label: l10n.spring_detail_report_note,
              value: report.note!,
            ),
        ],
      ),
    );
  }

  String _clarityLabel(WaterClarity clarity, AppLocalizations l10n) {
    return switch (clarity) {
      WaterClarity.crystalClear => l10n.water_clarity_crystal_clear,
      WaterClarity.clear => l10n.water_clarity_clear,
      WaterClarity.slightlyTurbid => l10n.water_clarity_slightly_turbid,
      WaterClarity.turbid => l10n.water_clarity_turbid,
      WaterClarity.heavilyTurbid => l10n.water_clarity_heavily_turbid,
    };
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: text.body2.copyWith(color: colors.neutral700),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: text.title2.copyWith(color: colors.neutral900),
            ),
          ),
        ],
      ),
    );
  }
}

/// Provenance tag for ČHMÚ station records: a Facebook-style verified badge
/// plus the source name. The badge alone conveys "verified", so the word is
/// never spelled out.
class _StationTag extends StatelessWidget {
  const _StationTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.verified_rounded, size: 16, color: colors.primaryMain),
        const SizedBox(width: 4),
        Text(
          label,
          style: text.body2.copyWith(color: colors.neutral700),
        ),
      ],
    );
  }
}
