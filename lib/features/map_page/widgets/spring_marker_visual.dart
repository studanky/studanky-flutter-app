import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';

({Color color, IconData glyph, bool filled}) springMarkerVisualFor(
  SpringIcon icon,
  AppColors colors,
) => switch (icon) {
  SpringIcon.flowing => (
    color: colors.statusFlowing,
    glyph: Icons.water_drop_rounded,
    filled: true,
  ),
  SpringIcon.notFlowing => (
    color: colors.statusNotFlowing,
    glyph: Icons.format_color_reset_rounded,
    filled: true,
  ),
  SpringIcon.stale => (
    color: colors.statusStale,
    glyph: Icons.schedule_rounded,
    filled: true,
  ),
  SpringIcon.unknown => (
    color: colors.statusUnknown,
    glyph: Icons.question_mark_rounded,
    filled: false,
  ),
};
