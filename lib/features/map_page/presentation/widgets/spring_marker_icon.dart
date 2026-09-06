import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/spring_marker_visual.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';

/// Standalone spring marker glyph shared by the map and its legend.
class SpringMarkerIcon extends StatelessWidget {
  const SpringMarkerIcon({
    super.key,
    required this.icon,
    this.size = 40,
    this.selected = false,
  });

  final SpringIcon icon;
  final double size;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.brightness == Brightness.dark;
    final visual = springMarkerVisualFor(icon, colors);
    final filled = visual.filled || selected;
    final color = selected ? colors.verified : visual.color;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: filled ? color : colors.onNeutral,
        shape: BoxShape.circle,
        border: Border.all(
          color: filled ? colors.markerRing : color,
          width: filled ? 2 : 2.5,
        ),
        boxShadow: [
          if (filled)
            BoxShadow(
              color: color.withValues(
                alpha: (isDark ? 0.6 : 0.45) + (selected ? 0.1 : 0),
              ),
              blurRadius: (isDark ? 16 : 12) + (selected ? 4 : 0),
              spreadRadius: (isDark ? 2 : 1) + (selected ? 1 : 0),
            ),
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
        color: filled ? colors.onPrimary : color,
      ),
    );
  }
}
