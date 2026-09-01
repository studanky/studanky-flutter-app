import 'dart:async';

import 'package:flutter/foundation.dart';

/// Disables map backdrop blur during camera updates and restores it after the
/// camera has stayed idle for [resumeDelay]. Repeated updates postpone the
/// restore without notifying listeners again while blur is already disabled.
class MapBackdropBlurController extends ValueNotifier<bool> {
  MapBackdropBlurController({
    this.resumeDelay = const Duration(milliseconds: 120),
  }) : super(true);

  final Duration resumeDelay;
  Timer? _resumeTimer;

  void onCameraMoved() {
    _resumeTimer?.cancel();
    if (value) value = false;
    _resumeTimer = Timer(resumeDelay, () {
      _resumeTimer = null;
      value = true;
    });
  }

  @override
  void dispose() {
    _resumeTimer?.cancel();
    super.dispose();
  }
}
