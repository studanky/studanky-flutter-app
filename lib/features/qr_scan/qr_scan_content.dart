import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanContent extends StatelessWidget {
  const QRScanContent({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileScanner();
  }
}
