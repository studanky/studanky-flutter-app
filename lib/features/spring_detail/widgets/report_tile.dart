import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/report.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/report_details.dart';
import 'package:studanky_flutter_app/features/springs/presentation/formatters/spring_formatters.dart';
import 'package:studanky_flutter_app/features/springs/presentation/widgets/spring_status_visuals.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Expandable report summary used by the spring history list.
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
    final colors = context.appColors;
    final text = context.appTextStyles;
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
                  if (report.isStationMeasurement)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: colors.verified,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.spring_detail_station_record,
                            style: text.body2.copyWith(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: colors.verified,
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
                          color: colors.neutral700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: ReportDetails(
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
