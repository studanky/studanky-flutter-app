import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

/// A permanent frosted strip behind the OS status bar over the full-bleed map,
/// so the system clock and indicators stay legible no matter what tiles sit
/// underneath (the iOS "status bar background" pattern). Frost (blur) removes
/// the busy map detail; a gentle wash — light under dark glyphs, dark under
/// light glyphs — guarantees contrast, fading into the map for a soft edge.
///
/// Visual only: it ignores pointers so the map stays interactive to the very
/// top. Pair it with an `AnnotatedRegion<SystemUiOverlayStyle>` so the glyph
/// brightness matches the wash.
class StatusBarScrim extends StatelessWidget {
  const StatusBarScrim({super.key});

  static const double _blurSigma = 26;
  static const double _fadeStartStop = 0.68;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.viewPaddingOf(context).top;
    if (height <= 0) return const SizedBox.shrink();

    final colors = Styles.appColors;
    final isDark = colors.brightness == Brightness.dark;
    final wash = isDark ? colors.background : colors.onNeutral;

    return IgnorePointer(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: ClipRect(
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, _fadeStartStop, 1],
              colors: [Colors.white, Colors.white, Colors.transparent],
            ).createShader(bounds),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0, _fadeStartStop, 1],
                    colors: [
                      wash.withValues(alpha: isDark ? 0.78 : 0.76),
                      wash.withValues(alpha: isDark ? 0.58 : 0.54),
                      wash.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
