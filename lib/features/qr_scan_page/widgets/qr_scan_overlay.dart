import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/entities/qr_scan_result.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/providers/qr_scan_provider.dart';

class QrScanOverlay extends StatelessWidget {
  const QrScanOverlay({super.key, required this.state, required this.onRescan});

  final QrScanState state;
  final Future<void> Function() onRescan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: state.capture.when(
              data: (result) => _buildDataPanel(theme, result),
              loading: () => _buildLoadingPanel(theme),
              error: (error, _) => _buildErrorPanel(theme, error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataPanel(ThemeData theme, QrScanResult? result) {
    if (result == null) {
      return _OverlayCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scan QR code',
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Align the code within the frame. Results show here.',
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
            'QR code detected',
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
            label: const Text('Scan again'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPanel(ThemeData theme) {
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
            'Processing…',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPanel(ThemeData theme, Object error) {
    return _OverlayCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scan failed',
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onRescan,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
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
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }
}
