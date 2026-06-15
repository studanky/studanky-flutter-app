import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

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

    return Semantics(
      button: true,
      label: 'Tekoucí voda neznamená pitná voda. Otevřít vysvětlení.',
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.onNeutral.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  'Tekoucí voda neznamená pitná voda',
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
