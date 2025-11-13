import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Provides a configured scanner controller and disposes it with the widget tree.
final qrScanControllerProvider = Provider.autoDispose<MobileScannerController>((
  ref,
) {
  final controller = MobileScannerController(
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );
  ref.onDispose(controller.dispose);
  return controller;
});
