import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Always-visible bottom notice that the app reports water *flow*, never
/// potability (spec §9.3, zadání §12). Deliberately understated — same visual
/// weight as the Mapy.com attribution it sits next to — so it never competes
/// with the map. Tapping opens the fuller explanation (the About dialog).
class MapDisclaimer extends StatelessWidget {
  const MapDisclaimer({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final l10n = context.l10n;

    return Semantics(
      button: true,
      label: l10n.map_potability_disclaimer_semantic,
      child: GestureDetector(
        onTap: onTap,
        // Translucent so the invisible padding counts as tap area: the visible
        // pill is ~24px tall, the padding grows the target to the 44px minimum
        // without changing the understated visual.
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          // Frosted-glass pill (the mockup's "liquid glass" disclaimer). Sheen
          // off — at this size it would read as a smudge — so the pill stays as
          // understated as the Mapy.com attribution it sits beside.
          child: GlassSurface(
            borderRadius: const BorderRadius.all(Radius.circular(kRadiusChip)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            sheen: false,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 13,
                  color: colors.secondaryVariant1,
                ),
                const SizedBox(width: 5),
                Text(
                  l10n.map_potability_disclaimer_title,
                  style: text.body2.copyWith(
                    fontSize: 11,
                    color: colors.neutral700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
