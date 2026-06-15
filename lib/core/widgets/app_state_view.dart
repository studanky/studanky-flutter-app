import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

/// Visual tone of an [AppStateView] — drives the accent colour of the icon coin.
enum AppStateTone { neutral, error }

/// One shared empty / offline / error state used across the app (zadání §22,
/// §23): a tinted icon coin, a title, an optional message and an optional
/// primary action. Keeps every full-surface state visually identical instead of
/// each screen rolling its own.
class AppStateView extends StatelessWidget {
  const AppStateView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.actionIcon,
    this.tone = AppStateTone.neutral,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? actionIcon;
  final AppStateTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final accent = tone == AppStateTone.error
        ? colors.error
        : colors.primaryMain;
    final hasAction = actionLabel != null && onAction != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: text.h5.copyWith(color: colors.neutral900),
            ),
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: text.body2.copyWith(color: colors.neutral700),
              ),
            ],
            if (hasAction) ...[
              const SizedBox(height: 20),
              if (actionIcon != null)
                FilledButton.icon(
                  onPressed: onAction,
                  icon: Icon(actionIcon, size: 18),
                  label: Text(actionLabel!),
                )
              else
                FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
