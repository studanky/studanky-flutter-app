import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/spring_owner.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/spring_photo.dart';
import 'package:studanky_flutter_app/features/spring_detail/utils/spring_formatters.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/status_visuals.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Top, always-visible part of the sheet: photo, name, freshness-led status,
/// coordinates and the primary actions. Rendered from the marker immediately
/// and enriched as the full detail resolves.
class SpringDetailHeader extends StatelessWidget {
  const SpringDetailHeader({
    required this.name,
    required this.statusIcon,
    required this.statusUpdatedAt,
    required this.position,
    required this.photo,
    required this.owner,
    required this.onShare,
    required this.onNavigate,
    required this.onCopyCoordinates,
    super.key,
  });

  final String name;
  final SpringIcon statusIcon;
  final DateTime? statusUpdatedAt;
  final LatLng position;
  final SpringPhoto? photo;
  final SpringOwner? owner;
  final VoidCallback onShare;
  final VoidCallback onNavigate;
  final VoidCallback onCopyCoordinates;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final status = headerStatusVisual(statusIcon, colors, l10n);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: text.h5.copyWith(color: colors.neutral900),
          ),
          const SizedBox(height: 8),
          _StatusRow(status: status, statusUpdatedAt: statusUpdatedAt),
          if (owner != null) ...[
            const SizedBox(height: 8),
            _OwnerTag(owner: owner!),
          ],
          const SizedBox(height: 8),
          _CoordinatesRow(position: position, onCopy: onCopyCoordinates),
          const SizedBox(height: 16),
          _ActionButtons(onShare: onShare, onNavigate: onNavigate),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.status, required this.statusUpdatedAt});

  final StatusVisual status;
  final DateTime? statusUpdatedAt;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final updatedAt = statusUpdatedAt;

    return Row(
      children: [
        Icon(status.icon, color: status.color, size: 22),
        const SizedBox(width: 6),
        Text(
          status.label,
          style: text.title1.copyWith(color: status.color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            updatedAt == null
                ? l10n.spring_detail_no_record_yet
                : SpringFormatters.relativeAge(l10n, updatedAt),
            style: text.body2.copyWith(color: colors.neutral700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _OwnerTag extends StatelessWidget {
  const _OwnerTag({required this.owner});

  final SpringOwner owner;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.primary50,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_outlined, size: 14, color: colors.primary900),
          const SizedBox(width: 4),
          Text(
            owner.name,
            style: text.body2.copyWith(color: colors.primary900),
          ),
        ],
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
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(Icons.place_outlined, size: 16, color: colors.neutral700),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                SpringFormatters.coordinates(position),
                style: text.body2.copyWith(color: colors.neutral700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.copy_rounded, size: 14, color: colors.neutral500),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.onShare, required this.onNavigate});

  final VoidCallback onShare;
  final VoidCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Styles.appColors;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onShare,
            icon: const Icon(Icons.ios_share_rounded, size: 18),
            label: Text(l10n.spring_detail_action_share),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.primary900,
              side: BorderSide(color: colors.neutral300),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: onNavigate,
            icon: const Icon(Icons.directions_rounded, size: 18),
            label: Text(l10n.spring_detail_action_navigate),
            style: FilledButton.styleFrom(
              backgroundColor: colors.primaryMain,
              foregroundColor: colors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

