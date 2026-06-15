import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';

/// Opaque elevated surface for modal content (dialogs, the spring-detail sheet).
/// It shares the floating glass controls' design language — same corner radius,
/// the same drop shadow and a faint top sheen — but stays solid so dense text
/// reads cleanly over the map. The "solid material" half of the surface system;
/// [GlassSurface] is the translucent half reserved for floating controls.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(kRadiusCard)),
    this.padding,
    this.sheen = true,
    this.shadows,
  });

  final Widget child;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry? padding;

  /// Subtle top highlight; mostly visible on the dark surface.
  final bool sheen;

  /// Drop shadow override (e.g. an upward-cast shadow for a bottom sheet, or
  /// `[]` to lean on a surrounding barrier). Defaults to the shared glass shadow.
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final isDark = colors.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.onNeutral,
        borderRadius: borderRadius,
        boxShadow: shadows ?? glassShadows(isDark),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            if (sheen)
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.white.withValues(alpha: isDark ? 0.06 : 0.04),
                          Colors.white.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Padding(padding: padding ?? EdgeInsets.zero, child: child),
          ],
        ),
      ),
    );
  }
}
