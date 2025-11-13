import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/entities/qr_scan_result.dart';
import 'package:studanky_flutter_app/features/qr_scan_page/providers/qr_scan_controller_provider.dart';

part 'qr_scan_provider.freezed.dart';

@freezed
abstract class QrScanState with _$QrScanState {
  const factory QrScanState({
    @Default(AsyncValue<QrScanResult?>.data(null))
    AsyncValue<QrScanResult?> capture,
  }) = _QrScanState;

  const QrScanState._();

  bool get isAwaitingDetection =>
      capture.maybeWhen(data: (result) => result == null, orElse: () => false);
}

final qrScanProvider =
    NotifierProvider.autoDispose<QrScanNotifier, QrScanState>(
      QrScanNotifier.new,
    );

class QrScanNotifier extends Notifier<QrScanState> {
  @override
  QrScanState build() => const QrScanState();

  MobileScannerController get _controller => ref.read(qrScanControllerProvider);

  /// Handles camera detections by transforming the payload into domain state.
  Future<void> handleDetection(BarcodeCapture capture) async {
    if (!state.isAwaitingDetection) {
      return;
    }

    state = state.copyWith(capture: const AsyncValue<QrScanResult?>.loading());

    final result = _mapCapture(capture);

    await _controller.stop();

    if (result == null) {
      state = state.copyWith(
        capture: AsyncValue<QrScanResult?>.error(
          const FormatException('QR kód neobsahuje platná data'),
          StackTrace.current,
        ),
      );
      return;
    }

    state = state.copyWith(capture: AsyncValue.data(result));
  }

  /// Resumes the live camera feed and clears the previously scanned payload.
  Future<void> resumeScanning() async {
    await _controller.start();
    state = state.copyWith(capture: const AsyncValue<QrScanResult?>.data(null));
  }

  QrScanResult? _mapCapture(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue ?? barcode.displayValue;
      if (value == null || value.trim().isEmpty) {
        continue;
      }

      return QrScanResult(
        value: value.trim(),
        format: barcode.format,
        scannedAt: DateTime.now(),
      );
    }
    return null;
  }
}
