import 'package:flutter/animation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Smoothly animates a [MapController]'s camera — centre, zoom and rotation —
/// which the controller itself can only change instantly.
///
/// A single reusable [AnimationController] drives `moveAndRotate` on every
/// tick; starting a new animation supersedes any in-flight one. Rotation takes
/// the shortest angular path and settles on a normalised value, so e.g. a
/// 350° → 0° reset turns +10° rather than spinning -350°.
class MapCameraAnimator {
  MapCameraAnimator({
    required MapController mapController,
    required TickerProvider vsync,
    this.defaultDuration = const Duration(milliseconds: 850),
    this.defaultCurve = Curves.easeInOutCubicEmphasized,
  }) : _mapController = mapController,
       _controller = AnimationController(vsync: vsync);

  final MapController _mapController;
  final Duration defaultDuration;
  final Curve defaultCurve;
  final AnimationController _controller;

  VoidCallback? _listener;
  bool _disposed = false;

  /// Animates any subset of {[center], [zoom], [rotation]} to the given target;
  /// omitted properties hold their current value. Completes when the animation
  /// finishes, or returns early (without throwing) if superseded.
  Future<void> animateTo({
    LatLng? center,
    double? zoom,
    double? rotation,
    Duration? duration,
    Curve? curve,
  }) async {
    if (_disposed) return;
    final camera = _mapController.camera;
    final beginCenter = camera.center;
    final beginZoom = camera.zoom;
    final beginRotation = camera.rotation;

    final endCenter = center ?? beginCenter;
    final endZoom = zoom ?? beginZoom;
    final targetRotation = rotation ?? beginRotation;
    final endRotation =
        beginRotation + _shortestDelta(beginRotation, targetRotation);

    _stop();

    final progress = _controller.drive(
      CurveTween(curve: curve ?? defaultCurve),
    );
    final latTween = Tween(
      begin: beginCenter.latitude,
      end: endCenter.latitude,
    );
    final lngTween = Tween(
      begin: beginCenter.longitude,
      end: endCenter.longitude,
    );
    final zoomTween = Tween(begin: beginZoom, end: endZoom);
    final rotationTween = Tween(begin: beginRotation, end: endRotation);

    void tick() {
      final t = progress.value;
      _mapController.moveAndRotate(
        LatLng(latTween.transform(t), lngTween.transform(t)),
        zoomTween.transform(t),
        rotationTween.transform(t),
      );
    }

    _listener = tick;
    _controller
      ..duration = duration ?? defaultDuration
      ..addListener(tick);

    try {
      await _controller.forward(from: 0);
      // Settle on the exact, normalised target (e.g. 360° collapses to 0°) so
      // the stored camera rotation stays canonical.
      _mapController.moveAndRotate(
        endCenter,
        endZoom,
        _normalize(targetRotation),
      );
    } on TickerCanceled {
      // Superseded by a newer animation — leave the camera where it is.
    } finally {
      if (!_disposed) _controller.removeListener(tick);
      if (identical(_listener, tick)) _listener = null;
    }
  }

  void _stop() {
    final listener = _listener;
    if (listener != null) {
      _controller.removeListener(listener);
      _listener = null;
    }
    if (_controller.isAnimating) _controller.stop(canceled: true);
  }

  /// Signed angular difference in (−180, 180] — the shortest way to turn.
  double _shortestDelta(double from, double to) {
    final diff = (to - from) % 360;
    if (diff > 180) return diff - 360;
    if (diff < -180) return diff + 360;
    return diff;
  }

  double _normalize(double degrees) {
    final d = degrees % 360;
    return d < 0 ? d + 360 : d;
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _stop();
    _controller.dispose();
  }
}
