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
/// reads as a neutral slate and "unknown" as a hollow pin, never as a confident
/// flow state. [semanticsLabel] is announced to screen readers (e.g. "Studánka
/// X: Teče").
Marker buildSpringMarker(
  SpringMarkerEntity spring,
  SpringIcon icon, {
  VoidCallback? onTap,
  String? semanticsLabel,
}) {
  return Marker(
    key: ValueKey('spring-${spring.documentId}'),
    point: spring.position,
    width: _springMarkerSize,
    height: _springMarkerSize,
    alignment: Alignment.center,
    // Keep upright when the map is rotated.
    rotate: true,
    child: _SpringMarkerPin(
      icon: icon,
      onTap: onTap,
      semanticsLabel: semanticsLabel,
    ),
  );
}

/// Visual treatment for each marker state: a status colour, a glyph and whether
/// the pin is filled (confident states) or hollow (unknown / no data).
({Color color, IconData glyph, bool filled}) _visualFor(
  SpringIcon icon,
  AppColors c,
) {
  return switch (icon) {
    SpringIcon.flowing => (
      color: c.statusFlowing,
      glyph: Icons.water_drop_rounded,
      filled: true,
    ),
    SpringIcon.notFlowing => (
      color: c.statusNotFlowing,
      glyph: Icons.format_color_reset_rounded,
      filled: true,
    ),
    SpringIcon.stale => (
      color: c.statusStale,
      glyph: Icons.schedule_rounded,
      filled: true,
    ),
    SpringIcon.unknown => (
      color: c.statusUnknown,
      glyph: Icons.question_mark_rounded,
      filled: false,
    ),
  };
}

class _SpringMarkerPin extends StatelessWidget {
  const _SpringMarkerPin({required this.icon, this.onTap, this.semanticsLabel});

  final SpringIcon icon;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: onTap,
        child: SpringMarkerIcon(icon: icon, size: _springMarkerSize),
      ),
    );
  }
}

/// The standalone pin glyph for a [SpringIcon] state. Confident states are a
/// filled coloured circle with a white ring, white glyph and a coloured glow;
/// the unknown state is a hollow pin — a surface-filled circle with a coloured
/// ring and glyph — so "no data" reads differently from any flow state. Shared
/// by the map marker and the About-sheet legend so both stay in lock-step.
class SpringMarkerIcon extends StatelessWidget {
  const SpringMarkerIcon({super.key, required this.icon, this.size = 40});

  final SpringIcon icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final isDark = colors.brightness == Brightness.dark;
    final visual = _visualFor(icon, colors);
    final filled = visual.filled;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // Hollow pins use the surface colour so the centre stays legible over
        // any map background; filled pins use the status colour.
        color: filled ? visual.color : colors.onNeutral,
        shape: BoxShape.circle,
        border: Border.all(
          color: filled ? colors.onPrimary : visual.color,
          width: filled ? 2 : 2.5,
        ),
        boxShadow: [
          // Coloured glow only on confident (filled) states; the hollow pin
          // stays quiet. Stronger on the dark (inverted) map.
          if (filled)
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
      child: Icon(
        visual.glyph,
        size: size * 0.45,
        color: filled ? colors.onPrimary : visual.color,
      ),
    );
  }
}
