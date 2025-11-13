import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

// TODO: handle error, stacktrace
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
    final showRefreshButton = onRefresh != null;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Styles.appColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: Styles.appColors.error,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title ?? context.l10n.error_widget_default_title,
              style: Styles.textStyles.title1.copyWith(
                color: Styles.appColors.neutral900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle ?? context.l10n.error_widget_default_subtitle,
              style: Styles.textStyles.body2.copyWith(
                color: Styles.appColors.neutral700,
              ),
              textAlign: TextAlign.center,
            ),
            if (showRefreshButton && onRefresh != null) ...[
              const SizedBox(height: 24),
              IntrinsicWidth(
                child: ElevatedButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: Text(
                    context.l10n.error_widget_default_try_again,
                    style: Styles.textStyles.button,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.appColors.primaryMain,
                    foregroundColor: Styles.appColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    minimumSize: const Size(0, 40),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
