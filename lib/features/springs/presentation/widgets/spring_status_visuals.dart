import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/shapes.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

class SpringStatusVisual {
  const SpringStatusVisual({
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;
}

SpringStatusVisual springStatusVisual(
  SpringIcon icon,
  AppColors colors,
  AppLocalizations l10n,
) {
  return switch (icon) {
    SpringIcon.flowing => SpringStatusVisual(
      color: colors.statusFlowing,
      icon: Icons.water_drop_rounded,
      label: l10n.spring_detail_status_flowing,
    ),
    SpringIcon.notFlowing => SpringStatusVisual(
      color: colors.statusNotFlowing,
      icon: Icons.do_not_disturb_on_rounded,
      label: l10n.spring_detail_status_not_flowing,
    ),
    SpringIcon.stale => SpringStatusVisual(
      color: colors.statusStale,
      icon: Icons.schedule_rounded,
      label: l10n.map_status_stale,
    ),
    SpringIcon.unknown => SpringStatusVisual(
      color: colors.statusUnknown,
      icon: Icons.help_rounded,
      label: l10n.spring_detail_status_unknown,
    ),
  };
}

SpringStatusVisual reportStatusVisual(
  bool isFlowing,
  AppColors colors,
  AppLocalizations l10n,
) {
  return isFlowing
      ? SpringStatusVisual(
          color: colors.statusFlowing,
          icon: Icons.water_drop_rounded,
          label: l10n.spring_detail_status_flowing,
        )
      : SpringStatusVisual(
          color: colors.statusNotFlowing,
          icon: Icons.do_not_disturb_on_rounded,
          label: l10n.spring_detail_status_not_flowing,
        );
}

class SpringStatusChip extends StatelessWidget {
  const SpringStatusChip({required this.visual, super.key});

  final SpringStatusVisual visual;

  @override
  Widget build(BuildContext context) {
    final text = Styles.textStyles;
    final colors = Styles.appColors;
    final foreground = Color.lerp(visual.color, colors.neutral900, 0.4)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ShapeDecoration(
        color: visual.color.withValues(alpha: 0.16),
        shape: squircleBorder(kRadiusChip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(visual.icon, color: foreground, size: 18),
          const SizedBox(width: 6),
          Text(visual.label, style: text.title2.copyWith(color: foreground)),
        ],
      ),
    );
  }
}
