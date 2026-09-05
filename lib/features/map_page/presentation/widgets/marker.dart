import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/spring_marker_icon.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/spring_marker_visual.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

const double _springMarkerSize = 40;

/// Size bump for the selected pin — the standard map-app selection cue
/// alongside the colour change.
const double _springMarkerSizeSelected = 46;

/// Side of the pointer tail (a rounded square rotated 45° into a diamond, like
/// the mockup) as a fraction of the coin diameter. The diamond is centred on
/// the coin's bottom edge, so its lower half shows as a short, blunt point whose
/// bottom vertex is the marker's exact geographic spot.
const double _tailSideRatio = 0.3;

/// Vertical drop of the tail's tip below the coin = half the diamond's diagonal
/// (the diamond straddles the coin's bottom edge).
const double _tailDropRatio = _tailSideRatio * math.sqrt2 / 2;

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
  final drop = coinSize * _tailDropRatio;

  return Marker(
    key: ValueKey('spring-${spring.documentId}'),
    point: spring.position,
    width: coinSize,
    height: coinSize + drop,
    // Anchor the geographic point at the tail's tip (box bottom), so the pin
    // sits *above* the spot and its point pricks it. flutter_map places the
    // point `0.5·h·(1 − alignment.y)` up from the box bottom, so `topCenter`
    // (y = −1) lands it exactly at the bottom edge. (Counter-intuitively named,
    // but that is flutter_map's convention.) The rotate anchor is the opposite
    // corner — bottom-centre — so a rotating map spins the pin around its tip.
    alignment: Alignment.topCenter,
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
    final colors = context.appColors;
    final isDark = colors.brightness == Brightness.dark;
    final visual = springMarkerVisualFor(icon, colors);
    // Mirror SpringMarkerIcon's colour logic so the tail matches the coin: a
    // selected pin is the trust green, otherwise the status colour; the hollow
    // "unknown" pin keeps a surface-filled tail with a coloured edge.
    final filled = visual.filled || selected;
    final color = selected ? colors.verified : visual.color;
    final coinSize = selected ? _springMarkerSizeSelected : _springMarkerSize;
    final drop = coinSize * _tailDropRatio;

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
              // Tail behind the coin: its bottom vertex is the exact point.
              Positioned.fill(
                child: CustomPaint(
                  painter: _PinPointerPainter(
                    color: color,
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

/// Paints the pin's tail: a small rounded square rotated 45° into a diamond
/// (the mockup's tail), straddling the coin's bottom edge so only its short,
/// blunt lower point shows — the bottom vertex is the marker's exact spot.
/// Solid status colour on confident pins; a surface diamond with a coloured
/// edge on the hollow "unknown" pin, matching its coin. Soft grounding shadow
/// under the tip (the coin carries its own drop shadow).
class _PinPointerPainter extends CustomPainter {
  const _PinPointerPainter({
    required this.color,
    required this.surface,
    required this.filled,
    required this.coinSize,
    required this.isDark,
  });

  final Color color;
  final Color surface;
  final bool filled;
  final double coinSize;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final side = coinSize * _tailSideRatio;
    // Diamond centred on the coin's bottom edge: its bottom vertex reaches the
    // very bottom of the box (the geographic point), its top half hides behind
    // the coin.
    final center = Offset(size.width / 2, size.height - side * math.sqrt2 / 2);
    final square = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: side, height: side),
      const Radius.circular(2.5),
    );

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: isDark ? 0.45 : 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = filled ? color : surface;
    // Hollow pins keep a coloured edge so the tail reads hollow like the coin;
    // confident pins are solid (the coin's white ring crosses the overlap).
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = color;

    void drawDiamond(Offset at, Paint paint) {
      canvas
        ..save()
        ..translate(at.dx, at.dy)
        ..rotate(math.pi / 4)
        ..drawRRect(square, paint)
        ..restore();
    }

    drawDiamond(center.translate(0, 1.5), shadowPaint);
    drawDiamond(center, fillPaint);
    if (!filled) drawDiamond(center, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _PinPointerPainter old) =>
      old.color != color ||
      old.surface != surface ||
      old.filled != filled ||
      old.coinSize != coinSize ||
      old.isDark != isDark;
}
