import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/water_clarity.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

/// Localized label for a water-clarity level, shared by the detail header and
/// the history rows so the word next to the clarity scale reads identically.
String waterClarityLabel(WaterClarity clarity, AppLocalizations l10n) =>
    switch (clarity) {
      WaterClarity.crystalClear => l10n.water_clarity_crystal_clear,
      WaterClarity.clear => l10n.water_clarity_clear,
      WaterClarity.slightlyTurbid => l10n.water_clarity_slightly_turbid,
      WaterClarity.turbid => l10n.water_clarity_turbid,
      WaterClarity.heavilyTurbid => l10n.water_clarity_heavily_turbid,
    };

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

/// Header status. Unlike the map marker — which may merge "stale" and "unknown"
/// into one neutral pin — the detail spells them apart (zadání §6, §18): "stale"
/// is a cool slate clock (an old report exists) and "unknown" a neutral help pin
/// (no report at all). Both read neutrally, never as a confident flow state, and
/// share the map's status colour tokens so the two stay in lock-step.
StatusVisual headerStatusVisual(
  SpringIcon icon,
  AppColors colors,
  AppLocalizations l10n,
) {
  return switch (icon) {
    SpringIcon.flowing => StatusVisual(
      color: colors.statusFlowing,
      icon: Icons.water_drop_rounded,
      label: l10n.spring_detail_status_flowing,
    ),
    SpringIcon.notFlowing => StatusVisual(
      color: colors.statusNotFlowing,
      icon: Icons.do_not_disturb_on_rounded,
      label: l10n.spring_detail_status_not_flowing,
    ),
    SpringIcon.stale => StatusVisual(
      color: colors.statusStale,
      icon: Icons.schedule_rounded,
      label: l10n.map_status_stale,
    ),
    SpringIcon.unknown => StatusVisual(
      color: colors.statusUnknown,
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
          color: colors.statusFlowing,
          icon: Icons.water_drop_rounded,
          label: l10n.spring_detail_status_flowing,
        )
      : StatusVisual(
          color: colors.statusNotFlowing,
          icon: Icons.do_not_disturb_on_rounded,
          label: l10n.spring_detail_status_not_flowing,
        );
}

/// Compact tonal status pill: the status colour at low alpha behind its glyph
/// and label (in the status colour). Used in the detail header so the spring's
/// state reads at a glance in the half-open sheet (zadání §14).
class StatusChip extends StatelessWidget {
  const StatusChip({required this.visual, super.key});

  final StatusVisual visual;

  @override
  Widget build(BuildContext context) {
    final text = Styles.textStyles;
    final colors = Styles.appColors;

    // Tonal pill (Material-3 style): a soft wash of the status hue behind a
    // *darkened* version of that hue. The vivid status colours (e.g. the
    // flowing blue) are too light to read as label/icon over a pale tint — only
    // ~2.6:1 — so the foreground is shifted toward the strongest text colour to
    // clear WCAG AA (~4.8:1). Lerping toward [neutral900] is theme-correct: it
    // darkens in light mode and lightens in dark mode.
    final foreground = Color.lerp(visual.color, colors.neutral900, 0.4)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        // Slightly stronger tint so the pill keeps a clear edge instead of
        // bleeding into the sheet.
        color: visual.color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(kRadiusChip),
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
