import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/widgets/app_state_view.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Full-surface error state with an optional retry. A thin wrapper over the
/// shared [AppStateView] so errors look the same everywhere.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.error,
    required this.stackTrace,
    this.title,
    this.subtitle,
    this.onRefresh,
  });

  final Object error;
  final StackTrace stackTrace;
  final String? title;
  final String? subtitle;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppStateView(
      tone: AppStateTone.error,
      icon: Icons.error_outline_rounded,
      title: title ?? l10n.error_widget_default_title,
      message: subtitle ?? l10n.error_widget_default_subtitle,
      actionLabel: onRefresh == null ? null : l10n.error_widget_default_try_again,
      actionIcon: Icons.refresh_rounded,
      onAction: onRefresh,
    );
  }
}
