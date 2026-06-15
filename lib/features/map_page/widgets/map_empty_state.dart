import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Non-blocking map overlay shown after the current viewport has loaded but
/// contains no springs. It explains the empty map without replacing the map,
/// so users can immediately pan or zoom out.
class MapEmptyState extends StatelessWidget {
  const MapEmptyState({super.key, required this.refreshing});

  final bool refreshing;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final l10n = context.l10n;
    final title = l10n.map_empty_title;
    final message = l10n.map_empty_message;

    return IgnorePointer(
      child: Semantics(
        container: true,
        liveRegion: true,
        label: '$title. $message',
        child: GlassSurface(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: colors.primaryMain.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: refreshing
                          ? SizedBox(
                              key: const ValueKey('map-empty-refreshing-icon'),
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2.2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colors.primary900,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.search_off_rounded,
                              key: const ValueKey('map-empty-icon'),
                              size: 20,
                              color: colors.primary900,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: text.title2.copyWith(color: colors.neutral900),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        message,
                        style: text.body2.copyWith(color: colors.neutral700),
                      ),
                    ],
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
