import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanContent extends StatelessWidget {
  const QrScanContent({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? messageStyle = Theme.of(context).textTheme.bodyMedium;
    return MobileScanner(
      placeholderBuilder: (context) => const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      ),
      errorBuilder: (context, error) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Unable to open the camera. Please check permissions and try again.',
            style: messageStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
