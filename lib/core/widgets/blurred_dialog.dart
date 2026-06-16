import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';

/// Shows [child] as a centred, iOS-style floating card over a background that
/// frosts (no dim) as the dialog animates in — the same glass backdrop as the
/// spring-detail sheet, so every overlay reads alike. Favourites and the About
/// panel use this instead of bottom sheets (which are reserved for the spring
/// detail). Tapping outside the card dismisses it; the card itself absorbs
/// taps. Resolves with whatever the card pops via `Navigator.pop`.
Future<T?> showBlurredDialog<T>({
  required BuildContext context,
  required Widget child,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 240),
    pageBuilder: (_, _, _) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, _, _) {
      final t = Curves.easeOutCubic.transform(animation.value);
      return Material(
        type: MaterialType.transparency,
        child: _BlurredDialogLayout(t: t, child: child),
      );
    },
  );
}

class _BlurredDialogLayout extends StatelessWidget {
  const _BlurredDialogLayout({required this.t, required this.child});

  /// Eased animation progress, 0 → 1.
  final double t;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated full-screen frost (no dim) — the same glass backdrop as the
        // spring-detail sheet; tapping it dismisses.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: kBackdropBlurSigma * t,
                sigmaY: kBackdropBlurSigma * t,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        // The card: scales and fades in, and swallows taps so they don't
        // bubble to the dismiss barrier.
        Center(
          child: Opacity(
            opacity: t,
            child: Transform.scale(
              scale: 0.94 + 0.06 * t,
              child: GestureDetector(
                onTap: () {},
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
