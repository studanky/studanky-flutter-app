import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

/// Frosted-glass surface used by the floating map controls (search bar, button
/// stack, zoom slider). Renders a backdrop blur behind a translucent fill with
/// a hairline edge highlight and a soft drop shadow — the design's
/// glassmorphism look, theme-aware via `Styles.appColors`.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding,
    this.blurSigma = 18,
    this.fill,
    this.border,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;

  /// Gaussian blur applied to whatever is painted behind the panel.
  final double blurSigma;

  /// Optional overrides; default to the theme's glass tokens.
  final Color? fill;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final isDark = colors.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.55 : 0.16),
            blurRadius: isDark ? 32 : 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: fill ?? colors.glassFill,
              borderRadius: borderRadius,
              border: Border.all(color: border ?? colors.glassBorder, width: 1),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
