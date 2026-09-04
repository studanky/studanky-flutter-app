import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/water_clarity.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/current_state_section.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/detail_section.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/spring_favorite_button.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/spring_hero_coordinates.dart';
import 'package:studanky_flutter_app/features/springs/presentation/formatters/spring_formatters.dart';
import 'package:studanky_flutter_app/features/springs/presentation/widgets/spring_status_visuals.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Hero, actions and current information shown above report history.
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
  final int? flowScale;
  final double? flowRateLps;
  final WaterClarity? clarity;
  final int maxFlowScale;
  final VoidCallback onShare;
  final VoidCallback onNavigate;
  final VoidCallback onCopyCoordinates;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final text = context.appTextStyles;
    final status = springStatusVisual(statusIcon, colors, l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 8, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: SelectionArea(
                    child: Text(
                      name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: text.h5.copyWith(color: colors.neutral900),
                    ),
                  ),
                ),
              ),
              SpringFavoriteButton(
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
              SpringStatusChip(visual: status),
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
        SpringHeroCoordinates(position: position, onCopy: onCopyCoordinates),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
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
        CurrentStateSection(
          statusIcon: statusIcon,
          flowScale: flowScale,
          flowRateLps: flowRateLps,
          clarity: clarity,
          maxFlowScale: maxFlowScale,
        ),
        if (description != null)
          DetailSection(
            title: l10n.spring_detail_section_about,
            child: SelectionArea(
              child: Text(
                description!,
                style: text.body2.copyWith(
                  color: colors.neutral800,
                  height: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
