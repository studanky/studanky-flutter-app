import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

const double _springMarkerSize = 40;

/// Builds a single spring marker, coloured **and shaped** by its three-state
/// [icon] (spec §4.1, §6). Each state carries a distinct glyph as well as a
/// colour so the status is legible for colour-blind users (zadání §6); "stale"
/// and "unknown" read neutrally, never as a confident flow state.
Marker buildSpringMarker(
  SpringMarkerEntity spring,
  SpringIcon icon, {
  VoidCallback? onTap,
}) {
  return Marker(
    key: ValueKey('spring-${spring.documentId}'),
    point: spring.position,
    width: _springMarkerSize,
    height: _springMarkerSize,
    alignment: Alignment.center,
    // Keep upright when the map is rotated.
    rotate: true,
    child: _SpringMarkerPin(icon: icon, onTap: onTap),
  );
}

/// Visual treatment for each marker state: a status colour and a glyph.
({Color color, IconData glyph}) _visualFor(SpringIcon icon, AppColors c) {
  return switch (icon) {
    SpringIcon.flowing => (
      color: c.primaryMain,
      glyph: Icons.water_drop_rounded,
    ),
    SpringIcon.notFlowing => (
      color: c.error,
      glyph: Icons.format_color_reset_rounded,
    ),
    SpringIcon.stale => (
      color: c.secondaryVariant1,
      glyph: Icons.schedule_rounded,
    ),
    SpringIcon.unknown => (
      color: c.neutral500,
      glyph: Icons.question_mark_rounded,
    ),
  };
}

class _SpringMarkerPin extends StatelessWidget {
  const _SpringMarkerPin({required this.icon, this.onTap});

  final SpringIcon icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SpringMarkerIcon(icon: icon, size: _springMarkerSize),
    );
  }
}

/// The standalone pin glyph for a [SpringIcon] state — a coloured circle with
/// a white ring, a status glyph and a coloured glow. Shared by the map marker
/// and the About-sheet legend so both stay in lock-step.
class SpringMarkerIcon extends StatelessWidget {
  const SpringMarkerIcon({super.key, required this.icon, this.size = 40});

  final SpringIcon icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final isDark = colors.brightness == Brightness.dark;
    final visual = _visualFor(icon, colors);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: visual.color,
        shape: BoxShape.circle,
        border: Border.all(color: colors.onPrimary, width: 2),
        boxShadow: [
          // Coloured glow — stronger on the dark (inverted) map.
          BoxShadow(
            color: visual.color.withValues(alpha: isDark ? 0.6 : 0.45),
            blurRadius: isDark ? 16 : 12,
            spreadRadius: isDark ? 2 : 1,
          ),
          // Grounding drop shadow for separation from the map.
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.22),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(visual.glyph, size: size * 0.45, color: colors.onPrimary),
    );
  }
}
