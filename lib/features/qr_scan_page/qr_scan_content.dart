import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/providers/qr_scan_provider.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/widgets/qr_scan_error.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/widgets/qr_scan_overlay.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

class QrScanContent extends StatelessWidget {
  const QrScanContent({
    super.key,
    required this.controller,
    required this.state,
    required this.onDetect,
    required this.onRescan,
  });

  final MobileScannerController controller;
  final QrScanState state;
  final void Function(BarcodeCapture capture) onDetect;
  final Future<void> Function() onRescan;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: MobileScanner(
            controller: controller,
            onDetect: onDetect,
            placeholderBuilder: (context) => const ColoredBox(
              color: Colors.black,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorBuilder: (context, error) =>
                QrScanError(message: context.l10n.qr_scan_camera_error),
          ),
        ),
        QrScanOverlay(state: state, onRescan: onRescan),
      ],
    );
  }
}
