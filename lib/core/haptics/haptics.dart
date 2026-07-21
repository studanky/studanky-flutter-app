import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

/// Single entry point for all haptic feedback in the app.
///
/// Call sites express *intent* (selection, tap, toggle, success…); the
/// intent→primitive mapping lives here so the whole app's haptic language can be
/// tuned in one place, globally disabled for a settings toggle, and silenced in
/// tests.
///
/// Guidelines this enforces (UX best practice):
/// * Haptics confirm a *meaningful* state change, never every touch.
/// * Intensity scales with significance: a quiet tick for discrete choices, a
///   light impact for routine commits, medium for a toggle that "landed", and a
///   composed double-tap for success/error.
/// * Never fired on continuous gestures (scroll, every frame of a pan/drag) — a
///   caller throttles those to detents or commit points.
///
/// Every method is fire-and-forget (returns `void`): a haptic must never block
/// or be awaited at the call site, so they stay one-liners free of `unawaited`.
///
/// Flutter's core [HapticFeedback] has no notification (success/warning/error)
/// generator, so those are composed from impacts. Swapping to a richer plugin
/// later only changes this file, not the call sites.
class Haptics {
  const Haptics._();

  /// Master switch. Wire to a SharedPreferences-backed setting later (Phase 5).
  /// On iOS the system "System Haptics" switch is honoured on top of this.
  static bool enabled = true;

  /// Discrete value change: a slider notch, a 1–5 scale step, expand/collapse,
  /// picking a list row. The subtlest cue.
  /// (iOS: `UISelectionFeedbackGenerator`; Android: `CLOCK_TICK`.)
  static void selection() => _fire(HapticFeedback.selectionClick);

  /// A light, routine commit: opening a detail/dialog, copying, sharing,
  /// recentring the map. (iOS: light `UIImpactFeedbackGenerator`.)
  static void tap() => _fire(HapticFeedback.lightImpact);

  /// A state toggle that "landed" — favourite ON, a measurement stopped.
  /// Slightly weightier and more rewarding than [tap].
  static void toggle() => _fire(HapticFeedback.mediumImpact);

  /// Crossing a destructive commit point, e.g. a swipe-to-delete arming.
  static void warning() => _fire(HapticFeedback.mediumImpact);

  /// A task completed. A light double-tap reads unmistakably as "done" without
  /// the user looking.
  static void success() => _pattern(HapticFeedback.lightImpact, 90);

  /// A failure: a failed submit/navigation. A firm double-tap.
  static void error() => _pattern(HapticFeedback.heavyImpact, 120);

  static bool get _active => enabled && !kIsWeb;

  static void _fire(Future<void> Function() primitive) {
    if (_active) unawaited(primitive());
  }

  /// Two pulses [gapMs] apart — the closest core [HapticFeedback] gets to a
  /// notification feel without an extra plugin.
  static void _pattern(Future<void> Function() primitive, int gapMs) {
    if (!_active) return;
    unawaited(() async {
      await primitive();
      await Future<void>.delayed(Duration(milliseconds: gapMs));
      await primitive();
    }());
  }
}
