import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/spring_owner.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/water_clarity.dart';
import 'package:studanky_flutter_app/features/spring_detail/utils/spring_formatters.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/detail_section.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/segment_scale.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/status_visuals.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Everything above the history list: the title block (name · favourite · status
/// · concrete age), the primary actions, and the iOS-style grouped sections —
/// "current state" (flow strength / rate / clarity, shown graphically), "about"
/// and "location & source". Each section and row is omitted when it has no data
/// so the detail never shows empty placeholders (zadání §14).
class SpringDetailHeader extends StatelessWidget {
  const SpringDetailHeader({
    required this.name,
    required this.statusIcon,
    required this.statusUpdatedAt,
    required this.position,
    required this.description,
    required this.flowScale,
    required this.flowRateLps,
    required this.clarity,
    required this.maxFlowScale,
    required this.owner,
    required this.onShare,
    required this.onNavigate,
    required this.onCopyCoordinates,
    required this.isFavorite,
    required this.onToggleFavorite,
    super.key,
  });

  final String name;
  final SpringIcon statusIcon;
  final DateTime? statusUpdatedAt;
  final LatLng position;
  final String? description;

  /// Current-state metrics (latest known); each null when not available.
  final int? flowScale;
  final double? flowRateLps;
  final WaterClarity? clarity;
  final int maxFlowScale;

  final SpringOwner? owner;
  final VoidCallback onShare;
  final VoidCallback onNavigate;
  final VoidCallback onCopyCoordinates;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final status = headerStatusVisual(statusIcon, colors, l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title block.
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 8, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: text.h5.copyWith(color: colors.neutral900),
                  ),
                ),
              ),
              _FavoriteButton(
                isFavorite: isFavorite,
                onPressed: onToggleFavorite,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
          child: Row(
            children: [
              StatusChip(visual: status),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  statusUpdatedAt == null
                      ? l10n.spring_detail_no_record_yet
                      : SpringFormatters.relativeAge(l10n, statusUpdatedAt!),
                  style: text.body2.copyWith(color: colors.neutral700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Primary actions.
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onShare,
                  icon: const Icon(Icons.ios_share_rounded, size: 18),
                  label: Text(l10n.spring_detail_action_share),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onNavigate,
                  icon: const Icon(Icons.directions_rounded, size: 18),
                  label: Text(l10n.spring_detail_action_navigate),
                ),
              ),
            ],
          ),
        ),
        _CurrentStateSection(
          flowScale: flowScale,
          flowRateLps: flowRateLps,
          clarity: clarity,
          maxFlowScale: maxFlowScale,
        ),
        if (description != null)
          DetailSection(
            title: l10n.spring_detail_section_about,
            child: Text(
              description!,
              style: text.body2.copyWith(color: colors.neutral800, height: 1.5),
            ),
          ),
        DetailSection(
          title: l10n.spring_detail_section_location,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _CoordinatesRow(position: position, onCopy: onCopyCoordinates),
              if (owner != null) ...[
                const Divider(height: 1, indent: 16, endIndent: 16),
                _SourceRow(owner: owner!),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// "Current state" grouped section: the latest flow strength (graphical 1…n),
/// measured discharge and water clarity (graphical). Hidden entirely when none
/// of the three is known.
class _CurrentStateSection extends StatelessWidget {
  const _CurrentStateSection({
    required this.flowScale,
    required this.flowRateLps,
    required this.clarity,
    required this.maxFlowScale,
  });

  final int? flowScale;
  final double? flowRateLps;
  final WaterClarity? clarity;
  final int maxFlowScale;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    final rows = <Widget>[
      if (flowScale != null)
        DetailMetricRow(
          label: l10n.spring_detail_report_flow_strength,
          value: _ScaleValue(
            scale: SegmentScale(value: flowScale!, max: maxFlowScale),
            label: '$flowScale/$maxFlowScale',
          ),
        ),
      if (flowRateLps != null)
        DetailMetricRow(
          label: l10n.spring_detail_report_flow_rate,
          value: Text(
            l10n.spring_detail_flow_rate_value(
              SpringFormatters.flowRate(flowRateLps!),
            ),
            style: text.title2.copyWith(color: colors.neutral900),
          ),
        ),
      if (clarity != null)
        DetailMetricRow(
          label: l10n.spring_detail_report_clarity,
          value: _ScaleValue(
            scale: SegmentScale(
              value: clarity!.clarityLevel,
              max: WaterClarity.maxLevel,
            ),
            label: waterClarityLabel(clarity!, l10n),
          ),
        ),
    ];

    if (rows.isEmpty) return const SizedBox.shrink();

    return DetailSection(
      title: l10n.spring_detail_section_current,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            rows[i],
          ],
        ],
      ),
    );
  }
}

/// A graphical scale plus its trailing word/number label, right-aligned.
class _ScaleValue extends StatelessWidget {
  const _ScaleValue({required this.scale, required this.label});

  final Widget scale;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        scale,
        const SizedBox(width: 10),
        Text(label, style: text.title2.copyWith(color: colors.neutral900)),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onPressed});

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Styles.appColors;

    return IconButton(
      onPressed: onPressed,
      tooltip: isFavorite
          ? l10n.spring_detail_remove_favorite
          : l10n.spring_detail_add_favorite,
      icon: Icon(
        isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        color: isFavorite ? colors.primaryMain : colors.neutral700,
      ),
    );
  }
}

class _CoordinatesRow extends StatelessWidget {
  const _CoordinatesRow({required this.position, required this.onCopy});

  final LatLng position;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return InkWell(
      onTap: onCopy,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.place_outlined, size: 18, color: colors.neutral700),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                SpringFormatters.coordinates(position),
                style: text.body2.copyWith(color: colors.neutral800),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.copy_rounded, size: 16, color: colors.neutral500),
          ],
        ),
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.owner});

  final SpringOwner owner;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(Icons.verified_rounded, size: 18, color: colors.primaryMain),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.spring_detail_source,
              style: text.body2.copyWith(color: colors.neutral700),
            ),
          ),
          Text(
            owner.name,
            style: text.title2.copyWith(color: colors.neutral900),
          ),
        ],
      ),
    );
  }
}
