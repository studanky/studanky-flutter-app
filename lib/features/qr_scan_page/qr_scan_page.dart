import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/providers/qr_scan_controller_provider.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/providers/qr_scan_provider.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/qr_scan_content.dart';

class QrScanPage extends ConsumerWidget {
  const QrScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(qrScanProvider);
    final controller = ref.watch(qrScanControllerProvider);
    final notifier = ref.read(qrScanProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner')),
      body: QrScanContent(
        controller: controller,
        state: state,
        onDetect: notifier.handleDetection,
        onRescan: notifier.resumeScanning,
      ),
    );
  }
}
