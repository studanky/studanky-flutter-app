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

/// How far the pointer tail extends *below* the round coin, as a fraction of
/// the coin diameter. The tail's apex is the marker's exact geographic point,
/// so the pin reads like a classic map pin: the coin floats, the tip pricks the
/// spot (the mockup's "šipička" that points precisely at the spring).
const double _pointerDropRatio = 0.34;

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
  final coinSize = selected ? _springMarkerSizeSelected : _springMarkerSize;
  final drop = coinSize * _pointerDropRatio;

  return Marker(
    key: ValueKey('spring-${spring.documentId}'),
    point: spring.position,
    width: coinSize,
    height: coinSize + drop,
    // Bottom-centre: flutter_map anchors the point at `0.5·height·(y+1)` down
    // the child, so `bottomCenter` puts the geographic point at the tail's
    // apex — the pin sits *above* the spot, tip touching it.
    alignment: Alignment.bottomCenter,
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
    final colors = Styles.appColors;
    final isDark = colors.brightness == Brightness.dark;
    final visual = _visualFor(icon, colors);
    // Mirror SpringMarkerIcon's colour logic so the tail matches the coin: a
    // selected pin is the trust green, otherwise the status colour; the hollow
    // "unknown" pin keeps a surface-filled tail with a coloured edge.
    final filled = visual.filled || selected;
    final color = selected ? colors.verified : visual.color;
    final coinSize = selected ? _springMarkerSizeSelected : _springMarkerSize;
    final drop = coinSize * _pointerDropRatio;

    return Semantics(
      button: true,
      selected: selected,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: onTap,
        // Whole pin (coin + tail) is one tap target.
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: coinSize,
          height: coinSize + drop,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Tail behind the coin: its apex is the marker's exact point.
              Positioned.fill(
                child: CustomPaint(
                  painter: _PinPointerPainter(
                    color: color,
                    ringColor: colors.markerRing,
                    surface: colors.onNeutral,
                    filled: filled,
                    coinSize: coinSize,
                    isDark: isDark,
                  ),
                ),
              ),
              // The round coin (status glyph + colour), on top of the tail base.
              Align(
                alignment: Alignment.topCenter,
                child: SpringMarkerIcon(
                  icon: icon,
                  size: coinSize,
                  selected: selected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Paints the downward tail beneath a spring pin's coin: an isoceles triangle
/// whose base tucks behind the coin and whose apex is the marker's exact
/// geographic point. Coloured (and ringed) to match the coin so the two read as
/// one map pin, with a soft grounding shadow under the tip.
class _PinPointerPainter extends CustomPainter {
  const _PinPointerPainter({
    required this.color,
    required this.ringColor,
    required this.surface,
    required this.filled,
    required this.coinSize,
    required this.isDark,
  });

  final Color color;
  final Color ringColor;
  final Color surface;
  final bool filled;
  final double coinSize;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    // Base sits well up inside the coin (hidden behind it); only the lower tip
    // shows below the coin's bottom edge.
    final baseHalf = coinSize * 0.24;
    final baseY = coinSize * 0.58;
    final path = Path()
      ..moveTo(cx - baseHalf, baseY)
      ..lineTo(cx + baseHalf, baseY)
      ..lineTo(cx, size.height)
      ..close();

    // Grounding shadow beneath the tip (the coin carries its own drop shadow).
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: isDark ? 0.45 : 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    // Fill — status colour for confident pins, surface for the hollow unknown.
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = filled ? color : surface;
    // Edge that continues the coin's ring: white on filled pins, the status
    // colour on the hollow one.
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = filled ? 2 : 2.5
      ..color = filled ? ringColor : color;

    canvas
      ..drawPath(path.shift(const Offset(0, 1.5)), shadowPaint)
      ..drawPath(path, fillPaint)
      ..drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _PinPointerPainter old) =>
      old.color != color ||
      old.ringColor != ringColor ||
      old.surface != surface ||
      old.filled != filled ||
      old.coinSize != coinSize ||
      old.isDark != isDark;
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
