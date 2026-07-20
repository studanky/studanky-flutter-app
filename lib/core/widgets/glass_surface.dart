import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/shapes.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

/// Shared visual tokens for the app's frosted-glass surfaces, so every floating
/// control over the map (search bar, button stack, zoom slider) reads as one
/// premium iOS-like family rather than three ad-hoc panels (zadání §3, §4).
const double kGlassRadius = kRadiusCard;
const double kGlassBlurSigma = 18;
const double kGlassBorderWidth = 1;

/// The two-layer drop shadow shared by every glass surface: a soft cast shadow
/// for lift plus a tight contact shadow for grounding. Heavier on the dark
/// (inverted) map so panels keep separation from the tiles.
List<BoxShadow> glassShadows(bool isDark) => [
  BoxShadow(
    color: Colors.black.withValues(alpha: isDark ? 0.50 : 0.16),
    blurRadius: isDark ? 28 : 22,
    offset: const Offset(0, 6),
  ),
  BoxShadow(
    color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08),
    blurRadius: 6,
    offset: const Offset(0, 2),
  ),
];

/// Frosted-glass surface used by every floating map control. Renders a backdrop
/// blur behind a translucent fill, a subtle top sheen highlight, a hairline edge
/// (painted above the sheen so it stays crisp) and the shared drop shadow — the
/// design's glassmorphism look, theme-aware via `Styles.appColors`. Corners are
/// squircles ([ClipRSuperellipse] + [squircleBorderFrom]) so the clip, the
/// hairline and the shape read as one continuous curve.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(kGlassRadius)),
    this.padding,
    this.blurSigma = kGlassBlurSigma,
    this.fill,
    this.sheen = true,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;

  /// Gaussian blur applied to whatever is painted behind the panel.
  final double blurSigma;

  /// Optional fill override; defaults to the theme's glass token.
  final Color? fill;

  /// Subtle top highlight that gives the glass its premium sheen. Disable for
  /// tiny surfaces where it would read as a smudge.
  final bool sheen;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final isDark = colors.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: glassShadows(isDark),
      ),
      child: ClipRSuperellipse(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          // Layered inside the clip: translucent fill → sheen → content →
          // hairline edge on top. The content (Padding) is the only
          // non-positioned child, so it sizes the stack and the rest fills it.
          child: Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: fill ?? colors.glassFill)),
              if (sheen)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.white.withValues(alpha: isDark ? 0.10 : 0.28),
                            Colors.white.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(padding: padding ?? EdgeInsets.zero, child: child),
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      shape: squircleBorderFrom(
                        borderRadius,
                        side: BorderSide(
                          color: colors.glassBorder,
                          width: kGlassBorderWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
