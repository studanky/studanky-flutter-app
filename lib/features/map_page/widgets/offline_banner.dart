import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Non-blocking map overlay shown when the device is offline. Map tiles need a
/// connection, but the map (and its cached tiles, markers, controls) stays
/// usable — so this advises rather than replaces, sharing the glass language
/// and layout of `MapEmptyState` so the two top-center statuses read as one
/// family. Sits in the same top-center slot as the empty state and takes
/// precedence over it (offline is the more specific reason for an empty map).
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final l10n = context.l10n;
    final title = l10n.offline_banner_title;
    final message = l10n.offline_banner_message;

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
                    child: Icon(
                      Icons.wifi_off_rounded,
                      size: 20,
                      color: colors.primary900,
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
