import 'dart:ui';

import 'package:flutter/material.dart';

/// Shows [child] as a centred, iOS-style floating card over a background that
/// blurs and dims as the dialog animates in — the look favourites and the
/// About panel use instead of bottom sheets (which are reserved for the spring
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
      return _BlurredDialogLayout(t: t, child: child);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Animated blur + dim covering the whole screen; tapping it dismisses.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22 * t, sigmaY: 22 * t),
              child: ColoredBox(
                color: Colors.black.withValues(
                  alpha: (isDark ? 0.45 : 0.25) * t,
                ),
              ),
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
