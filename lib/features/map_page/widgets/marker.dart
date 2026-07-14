import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

const double _springMarkerSize = 40;

/// Size bump for the selected pin — the standard map-app selection cue
/// alongside the colour change.
const double _springMarkerSizeSelected = 46;

/// Builds a single spring marker, coloured **and shaped** by its three-state
/// [icon] (spec §4.1, §6). Each state carries a distinct glyph as well as a
/// colour so the status is legible for colour-blind users (zadání §6); "stale"
/// reads as a neutral slate and "unknown" as a hollow pin, never as a confident
/// flow state. [semanticsLabel] is announced to screen readers (e.g. "Studánka
/// X: Teče").
///
/// [selected] marks the spring whose detail sheet is currently open: the pin
/// grows slightly and turns the trust green so it stands out among
/// neighbouring pins (its status stays readable from the glyph).
Marker buildSpringMarker(
  SpringMarkerEntity spring,
  SpringIcon icon, {
  VoidCallback? onTap,
  String? semanticsLabel,
  bool selected = false,
}) {
  final size = selected ? _springMarkerSizeSelected : _springMarkerSize;

  return Marker(
    key: ValueKey('spring-${spring.documentId}'),
    point: spring.position,
    width: size,
    height: size,
    alignment: Alignment.center,
    // Keep upright when the map is rotated.
    rotate: true,
    child: _SpringMarkerPin(
      icon: icon,
      onTap: onTap,
      semanticsLabel: semanticsLabel,
      selected: selected,
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
  const _SpringMarkerPin({
    required this.icon,
    this.onTap,
    this.semanticsLabel,
    this.selected = false,
  });

  final SpringIcon icon;
  final VoidCallback? onTap;
  final String? semanticsLabel;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: onTap,
        child: SpringMarkerIcon(
          icon: icon,
          size: selected ? _springMarkerSizeSelected : _springMarkerSize,
          selected: selected,
        ),
      ),
    );
  }
}

/// The standalone pin glyph for a [SpringIcon] state. Confident states are a
/// filled coloured circle with a white ring, white glyph and a coloured glow;
/// the unknown state is a hollow pin — a surface-filled circle with a coloured
/// ring and glyph — so "no data" reads differently from any flow state. Shared
/// by the map marker and the About-sheet legend so both stay in lock-step.
///
/// [selected] recolours the pin (fill + glow) to the ČHMÚ trust green
/// ([AppColors.verified]) — green is the one hue no *status* uses, so "this is
/// the open spring" can't be mistaken for a flow state, while the glyph keeps
/// telling the status.
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
    final colors = Styles.appColors;
    final isDark = colors.brightness == Brightness.dark;
    final visual = _visualFor(icon, colors);
    // The selected pin is always a solid green coin — even the hollow
    // "unknown" pin fills up, so selection reads identically everywhere.
    final filled = visual.filled || selected;
    final color = selected ? colors.verified : visual.color;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // Hollow pins use the surface colour so the centre stays legible over
        // any map background; filled pins use the status colour.
        color: filled ? color : colors.onNeutral,
        shape: BoxShape.circle,
        // [markerRing], not [onPrimary]: the ring's job is separation from the
        // map tiles and stays white in both themes (dark onPrimary is navy).
        border: Border.all(
          color: filled ? colors.markerRing : color,
          width: filled ? 2 : 2.5,
        ),
        boxShadow: [
          // Coloured glow only on confident (filled) states; the hollow pin
          // stays quiet. Stronger on the dark (inverted) map, and a touch
          // stronger again for the selected pin so it pops among neighbours.
          if (filled)
            BoxShadow(
              color: color.withValues(
                alpha: (isDark ? 0.6 : 0.45) + (selected ? 0.1 : 0),
              ),
              blurRadius: (isDark ? 16 : 12) + (selected ? 4 : 0),
              spreadRadius: (isDark ? 2 : 1) + (selected ? 1 : 0),
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
      // The glyph keeps [onPrimary]: white over the saturated light-theme
      // fills, deep navy over the brightened dark-theme fills (5.8–8.5:1).
      child: Icon(
        visual.glyph,
        size: size * 0.45,
        color: filled ? colors.onPrimary : color,
      ),
    );
  }
}
