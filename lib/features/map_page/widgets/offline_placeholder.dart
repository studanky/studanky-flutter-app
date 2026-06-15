import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/widgets/app_state_view.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Shown instead of the map when the device is offline (map tiles need a
/// connection). Uses the shared [AppStateView] so it matches every other
/// empty/error state in the app.
class OfflinePlaceholder extends StatelessWidget {
  const OfflinePlaceholder({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: AppStateView(
        icon: Icons.wifi_off_rounded,
        title: l10n.offline_placeholder_title,
        message: l10n.offline_placeholder_message_offline,
        actionLabel: l10n.error_widget_default_try_again,
        actionIcon: Icons.refresh_rounded,
        onAction: onRetry,
      ),
    );
  }
}
