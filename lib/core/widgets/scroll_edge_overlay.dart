import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

/// Visual fade and backdrop blur displayed at one scrollable edge.
class ScrollEdgeOverlay extends StatelessWidget {
  const ScrollEdgeOverlay({
    super.key,
    required this.visible,
    required this.isTop,
    required this.blurSigma,
    required this.tint,
  });

  final bool visible;
  final bool isTop;
  final double blurSigma;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final colors = context.appColors;
    final isDark = colors.brightness == Brightness.dark;
    final baseTint = tint ?? (isDark ? colors.background : colors.onNeutral);
    final shade = isDark ? Colors.black : colors.neutral900;
    final edgeAlpha = mediaQuery.highContrast
        ? (isDark ? 0.90 : 0.94)
        : (isDark ? 0.78 : 0.88);
    final midAlpha = mediaQuery.highContrast
        ? (isDark ? 0.68 : 0.72)
        : (isDark ? 0.52 : 0.62);
    final shadeEdgeAlpha = mediaQuery.highContrast
        ? (isDark ? 0.30 : 0.12)
        : (isDark ? 0.20 : 0.07);
    final shadeMidAlpha = mediaQuery.highContrast
        ? (isDark ? 0.14 : 0.06)
        : (isDark ? 0.08 : 0.03);

    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: mediaQuery.disableAnimations
            ? Duration.zero
            : const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: ClipRect(
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isTop
                  ? const [Colors.white, Colors.transparent]
                  : const [Colors.transparent, Colors.white],
            ).createShader(bounds),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0, 0.52, 1],
                          colors: isTop
                              ? [
                                  baseTint.withValues(alpha: edgeAlpha),
                                  baseTint.withValues(alpha: midAlpha),
                                  baseTint.withValues(alpha: 0),
                                ]
                              : [
                                  baseTint.withValues(alpha: 0),
                                  baseTint.withValues(alpha: midAlpha),
                                  baseTint.withValues(alpha: edgeAlpha),
                                ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0, 0.42, 1],
                          colors: isTop
                              ? [
                                  shade.withValues(alpha: shadeEdgeAlpha),
                                  shade.withValues(alpha: shadeMidAlpha),
                                  shade.withValues(alpha: 0),
                                ]
                              : [
                                  shade.withValues(alpha: 0),
                                  shade.withValues(alpha: shadeMidAlpha),
                                  shade.withValues(alpha: shadeEdgeAlpha),
                                ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox.expand(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
