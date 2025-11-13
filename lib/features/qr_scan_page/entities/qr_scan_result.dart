import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

part 'qr_scan_result.freezed.dart';

@freezed
abstract class QrScanResult with _$QrScanResult {
  const factory QrScanResult({
    required String value,
    required BarcodeFormat? format,
    required DateTime scannedAt,
  }) = _QrScanResult;

  const QrScanResult._();

  String get formatLabel =>
      format?.name.replaceAll('_', ' ').toUpperCase() ?? 'UNKNOWN';
}
