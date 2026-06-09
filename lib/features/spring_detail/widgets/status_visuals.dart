import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

/// Resolved color + glyph + label for a spring/report flow status, so the
/// header chip and the history rows read identically.
class StatusVisual {
  const StatusVisual({
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;
}

/// Header status, including the client-computed "stale"/"unknown" states which
/// must read neutrally — never as a confident flow state (spec §4.1).
StatusVisual headerStatusVisual(
  SpringIcon icon,
  AppColors colors,
  AppLocalizations l10n,
) {
  return switch (icon) {
    SpringIcon.flowing => StatusVisual(
      color: colors.primaryMain,
      icon: Icons.water_drop_rounded,
      label: l10n.spring_detail_status_flowing,
    ),
    SpringIcon.notFlowing => StatusVisual(
      color: colors.error,
      icon: Icons.do_not_disturb_on_rounded,
      label: l10n.spring_detail_status_not_flowing,
    ),
    SpringIcon.stale || SpringIcon.unknown => StatusVisual(
      color: colors.neutral500,
      icon: Icons.help_rounded,
      label: l10n.spring_detail_status_unknown,
    ),
  };
}

/// Per-report status from the raw `is_flowing` flag. Reports are historical
/// facts, so they never go "stale".
StatusVisual reportStatusVisual(
  bool isFlowing,
  AppColors colors,
  AppLocalizations l10n,
) {
  return isFlowing
      ? StatusVisual(
          color: colors.primaryMain,
          icon: Icons.water_drop_rounded,
          label: l10n.spring_detail_status_flowing,
        )
      : StatusVisual(
          color: colors.error,
          icon: Icons.do_not_disturb_on_rounded,
          label: l10n.spring_detail_status_not_flowing,
        );
}
