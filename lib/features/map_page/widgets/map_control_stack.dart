import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/map_page/providers/user_location_provider.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Left vertical stack of floating glass controls over the map (zadání §7):
/// location/compass, favourites, and help — ordered by reach/priority within
/// thumb range. The right edge is reserved for the zoom slider.
class MapControlStack extends StatelessWidget {
  const MapControlStack({
    super.key,
    required this.locationStatus,
    required this.isLocating,
    required this.rotationRad,
    required this.centered,
    required this.favoritesCount,
    required this.onLocation,
    required this.onFavorites,
    required this.onHelp,
  });

  final LocationStatus locationStatus;
  final bool isLocating;
  final double rotationRad;
  final bool centered;
  final int favoritesCount;
  final VoidCallback onLocation;
  final VoidCallback onFavorites;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final l10n = context.l10n;

    // The button stays a neutral glass tile in every state so the red north
    // needle keeps strong contrast (an orange/amber fill washed it out). Map
    // rotation is signalled by the rotating needle; being centred on the user
    // is signalled by the filled blue centre dot.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassIconButton(
          semanticLabel: l10n.map_my_location,
          onTap: isLocating ? null : onLocation,
          child: isLocating
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: colors.primaryMain,
                  ),
                )
              : CustomPaint(
                  size: const Size.square(24),
                  painter: CompassPainter(
                    rotationRad: rotationRad,
                    centered: centered,
                    northColor: colors.error,
                    armColor: colors.neutral500,
                    dotColor: centered ? colors.primaryMain : colors.neutral700,
                  ),
                ),
        ),
        const SizedBox(height: 10),
        GlassIconButton(
          semanticLabel: l10n.map_favorites,
          onTap: onFavorites,
          child: Badge(
            isLabelVisible: favoritesCount > 0,
            label: Text('$favoritesCount'),
            child: Icon(
              Icons.favorite_rounded,
              size: 20,
              color: colors.primaryMain,
            ),
          ),
        ),
        const SizedBox(height: 10),
        GlassIconButton(
          semanticLabel: MaterialLocalizations.of(context).moreButtonTooltip,
          onTap: onHelp,
          child: Icon(
            Icons.help_outline_rounded,
            size: 20,
            color: colors.neutral700,
          ),
        ),
      ],
    );
  }
}

/// 44×44 frosted-glass square button. When [accent] is set it fills with that
/// colour and glows (active state); otherwise it's a neutral glass tile.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.child,
    required this.semanticLabel,
    this.onTap,
    this.accent,
  });

  final Widget child;
  final String semanticLabel;
  final VoidCallback? onTap;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final isDark = colors.brightness == Brightness.dark;
    final active = accent != null;
    const radius = BorderRadius.all(Radius.circular(16));

    return Semantics(
      button: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            if (active)
              BoxShadow(
                color: accent!.withValues(alpha: 0.4),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.16),
              blurRadius: isDark ? 28 : 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Material(
              color: active ? accent : colors.glassFill,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    border: Border.all(
                      color: active
                          ? colors.onPrimary.withValues(alpha: 0.5)
                          : colors.glassBorder,
                    ),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A small compass: a red arrow always pointing to true north (rotates with
/// the map), neutral S/E/W arms, and a centre dot that fills when the map is
/// centred on the user. Mirrors the mapy.com-style location/orient control.
class CompassPainter extends CustomPainter {
  CompassPainter({
    required this.rotationRad,
    required this.centered,
    required this.northColor,
    required this.armColor,
    required this.dotColor,
  });

  final double rotationRad;
  final bool centered;
  final Color northColor;
  final Color armColor;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final arm = size.width / 2;

    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..rotate(rotationRad);

    final armPaint = Paint()
      ..color = armColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas
      ..drawLine(Offset.zero, Offset(0, arm), armPaint)
      ..drawLine(Offset.zero, Offset(arm, 0), armPaint)
      ..drawLine(Offset.zero, Offset(-arm, 0), armPaint);

    final northPaint = Paint()
      ..color = northColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(0, -arm + 3), northPaint);

    final tip = ui.Path()
      ..moveTo(0, -arm - 1)
      ..lineTo(-3.5, -arm + 5)
      ..lineTo(3.5, -arm + 5)
      ..close();
    canvas
      ..drawPath(tip, Paint()..color = northColor)
      ..restore();

    if (centered) {
      canvas.drawCircle(center, 3.2, Paint()..color = dotColor);
    } else {
      canvas.drawCircle(
        center,
        3,
        Paint()
          ..color = dotColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(CompassPainter old) =>
      old.rotationRad != rotationRad ||
      old.centered != centered ||
      old.northColor != northColor ||
      old.armColor != armColor ||
      old.dotColor != dotColor;
}
