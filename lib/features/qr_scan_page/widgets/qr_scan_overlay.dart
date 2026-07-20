import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/styles/shapes.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/entities/qr_scan_result.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/providers/qr_scan_provider.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

class QrScanOverlay extends StatelessWidget {
  const QrScanOverlay({super.key, required this.state, required this.onRescan});

  final QrScanState state;
  final Future<void> Function() onRescan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: state.capture.when(
              data: (result) => _buildDataPanel(theme, l10n, result),
              loading: () => _buildLoadingPanel(theme, l10n),
              error: (error, _) => _buildErrorPanel(theme, l10n, error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataPanel(
    ThemeData theme,
    AppLocalizations l10n,
    QrScanResult? result,
  ) {
    if (result == null) {
      return _OverlayCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.qr_scan_title,
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.qr_scan_message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      );
    }

    return _OverlayCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.qr_scan_detected_title,
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            result.value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${result.formatLabel} • ${_formatTimestamp(result.scannedAt)}',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onRescan,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.qr_scan_again),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPanel(ThemeData theme, AppLocalizations l10n) {
    return _OverlayCard(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(
            l10n.qr_scan_processing,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPanel(
    ThemeData theme,
    AppLocalizations l10n,
    Object error,
  ) {
    final message = error is FormatException
        ? l10n.qr_scan_invalid_data
        : error.toString();

    return _OverlayCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.qr_scan_failed,
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onRescan,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.qr_scan_try_again),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime instant) {
    final hour = instant.hour.toString().padLeft(2, '0');
    final minute = instant.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _OverlayCard extends StatelessWidget {
  const _OverlayCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        shape: squircleBorder(16),
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }
}
