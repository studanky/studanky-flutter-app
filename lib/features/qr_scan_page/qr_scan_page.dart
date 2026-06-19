import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/haptics/haptics.dart';
import 'package:studanky_flutter_app/core/navigation/app_router.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/providers/qr_scan_controller_provider.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/providers/qr_scan_provider.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/qr_scan_content.dart';

class QrScanPage extends ConsumerWidget {
  const QrScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // A clean scan resolves to a spring id → leave the scanner and open the
    // detail. `go` rebuilds the stack to [map, spring], so the scanner drops out
    // and Back returns to the map. The detail has no marker in hand, so it
    // fetches the spring by id (the deep-link fallback path).
    ref.listen(qrScanProvider, (previous, next) {
      final result = next.capture.value;
      if (result == null) return;
      final documentId = _springIdFromPayload(result.value);
      if (documentId == null) return;
      SpringRoute(documentId: documentId).go(context);
    });

    final state = ref.watch(qrScanProvider);
    final controller = ref.watch(qrScanControllerProvider);
    final notifier = ref.read(qrScanProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner')),
      body: QrScanContent(
        controller: controller,
        state: state,
        onDetect: notifier.handleDetection,
        onRescan: () {
          Haptics.tap();
          return notifier.resumeScanning();
        },
      ),
    );
  }
}

/// Extracts a spring document id from a scanned QR payload.
///
/// Provisional: the final QR scheme is TBD (it will be settled alongside the
/// OS-level deep links in a later phase). For now we accept either a bare id or
/// a URL whose last non-empty path segment is the id (e.g.
/// `https://…/spring/<id>`).
String? _springIdFromPayload(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;

  final uri = Uri.tryParse(trimmed);
  if (uri != null && uri.hasScheme) {
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.isNotEmpty) return segments.last;
  }
  return trimmed;
}
