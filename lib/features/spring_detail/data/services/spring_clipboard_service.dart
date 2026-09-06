import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class SpringClipboardService {
  Future<void> copy(String text);
}

class PlatformSpringClipboardService implements SpringClipboardService {
  const PlatformSpringClipboardService();

  @override
  Future<void> copy(String text) {
    return Clipboard.setData(ClipboardData(text: text));
  }
}

final springClipboardServiceProvider = Provider<SpringClipboardService>(
  (_) => const PlatformSpringClipboardService(),
);
