import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Adds Google Maps-style one-finger quick zoom around a [FlutterMap].
///
/// The first tap is released; the second is held and dragged vertically. The
/// gap between taps is time-limited, but once the second pointer is down it may
/// be held for any length of time before dragging.
///
/// This is a workaround for a `flutter_map` bug where the built-in
/// `doubleTapDragZoom` expires the whole gesture shortly after the first tap,
/// even when the second pointer is already down. Remove this workaround once
/// <https://github.com/fleaflet/flutter_map/issues/2246> is fixed in the minimum
/// supported `flutter_map` version.
class MapQuickZoom extends StatefulWidget {
  const MapQuickZoom({
    required this.controller,
    required this.minZoom,
    required this.maxZoom,
    required this.child,
    this.onZoomStart,
    super.key,
  });

  final MapController controller;
  final double minZoom;
  final double maxZoom;
  final Widget child;
  final VoidCallback? onZoomStart;

  @override
  State<MapQuickZoom> createState() => _MapQuickZoomState();
}

class _MapQuickZoomState extends State<MapQuickZoom> {
  /// Matches `flutter_map`'s double-tap recognition window and spatial slop so
  /// a quick zoom candidate is exactly the same gesture as a normal double tap.
  static const Duration _doubleTapTimeout = Duration(milliseconds: 250);
  static const double _doubleTapMaxOffset = 48;

  final Set<int> _pointersDown = {};
  int? _activePointer;
  Offset? _pointerDownPosition;
  bool _pointerMoved = false;

  Duration? _firstTapUpTime;
  Offset? _firstTapPosition;

  bool _quickZoomCandidate = false;
  bool _quickZoomActive = false;
  double? _quickZoomStartY;
  double? _quickZoomStartLevel;
  LatLng? _quickZoomStartCenter;

  void _onPointerDown(PointerDownEvent event) {
    _pointersDown.add(event.pointer);
    if (_pointersDown.length != 1 || event.buttons & kPrimaryButton == 0) {
      _cancelSequence();
      return;
    }

    _activePointer = event.pointer;
    _pointerDownPosition = event.localPosition;
    _pointerMoved = false;

    final firstTapUpTime = _firstTapUpTime;
    final firstTapPosition = _firstTapPosition;
    final followsFirstTap =
        firstTapUpTime != null &&
        firstTapPosition != null &&
        event.timeStamp - firstTapUpTime <= _doubleTapTimeout &&
        (event.localPosition - firstTapPosition).distance <=
            _doubleTapMaxOffset;

    if (!followsFirstTap) {
      _quickZoomCandidate = false;
      _firstTapUpTime = null;
      _firstTapPosition = null;
      return;
    }

    final camera = widget.controller.camera;
    _quickZoomCandidate = true;
    _firstTapUpTime = null;
    _firstTapPosition = null;
    _quickZoomStartY = event.localPosition.dy;
    _quickZoomStartLevel = camera.zoom;
    _quickZoomStartCenter = camera.center;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (event.pointer != _activePointer) return;

    final downPosition = _pointerDownPosition;
    if (downPosition == null) return;
    final dragDistance = (event.localPosition - downPosition).distance;
    if (dragDistance > kTouchSlop) _pointerMoved = true;

    if (!_quickZoomCandidate || dragDistance <= kTouchSlop) return;
    if (!_quickZoomActive) {
      _quickZoomActive = true;
      widget.onZoomStart?.call();
    }

    _applyZoom(event.localPosition.dy);
  }

  void _applyZoom(double currentY) {
    final startY = _quickZoomStartY;
    final startLevel = _quickZoomStartLevel;
    final startCenter = _quickZoomStartCenter;
    if (startY == null || startLevel == null || startCenter == null) return;

    // Same adaptive sensitivity and direction as flutter_map / Google Maps:
    // down zooms in, up zooms out, with greater range at street-level zooms.
    final targetZoom = (startLevel + (currentY - startY) * startLevel / 360)
        .clamp(widget.minZoom, widget.maxZoom)
        .toDouble();
    widget.controller.move(startCenter, targetZoom);
  }

  void _onPointerUp(PointerUpEvent event) {
    _pointersDown.remove(event.pointer);
    if (event.pointer != _activePointer) return;

    if (_quickZoomCandidate) {
      if (_quickZoomActive) _applyZoom(event.localPosition.dy);
      _clearCurrentPointer();
      _quickZoomCandidate = false;
      _quickZoomActive = false;
      return;
    }

    if (!_pointerMoved && _pointersDown.isEmpty) {
      _firstTapUpTime = event.timeStamp;
      _firstTapPosition = event.localPosition;
    }
    _clearCurrentPointer();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _pointersDown.remove(event.pointer);
    _cancelSequence();
  }

  void _clearCurrentPointer() {
    _activePointer = null;
    _pointerDownPosition = null;
    _pointerMoved = false;
    _quickZoomStartY = null;
    _quickZoomStartLevel = null;
    _quickZoomStartCenter = null;
  }

  void _cancelSequence() {
    _clearCurrentPointer();
    _firstTapUpTime = null;
    _firstTapPosition = null;
    _quickZoomCandidate = false;
    _quickZoomActive = false;
  }

  @override
  Widget build(BuildContext context) => Listener(
    behavior: HitTestBehavior.translucent,
    onPointerDown: _onPointerDown,
    onPointerMove: _onPointerMove,
    onPointerUp: _onPointerUp,
    onPointerCancel: _onPointerCancel,
    child: widget.child,
  );
}
