import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

abstract final class MapViewConfig {
  static const initialCenter = LatLng(49.5630, 15.9398);
  static const defaultZoom = 14.5;
  static const minZoom = 5.0;
  static const maxZoom = 19.0;
  static const clusterExpandZoomBoost = 1.5;
  static const recenterMinZoom = 15.0;
  static const springSearchZoom = 17.0;
  static const detailFocusDownwardOffset = 24.0;
  static const centeredThresholdMeters = 25.0;
  static const northEpsilonDegrees = 1.0;
  static const searchMaxFitZoom = 16.0;
  static const cameraDebounce = Duration(milliseconds: 300);
  static const emptyStateRevealDelay = Duration(milliseconds: 450);
  static const searchBarHideDuration = Duration(milliseconds: 220);
  static const bottomLegalStripMinimumGap = 8.0;

  static const interactionFlags =
      InteractiveFlag.pinchZoom |
      InteractiveFlag.pinchMove |
      InteractiveFlag.doubleTapZoom |
      InteractiveFlag.drag |
      InteractiveFlag.rotate;

  static const pinchGestureWinGestures =
      MultiFingerGesture.pinchZoom | MultiFingerGesture.pinchMove;
  static const pinchZoomGestureThreshold = 0.12;
  static const rotationGestureThresholdDegrees = 20.0;

  static const userMoveSources = <MapEventSource>{
    MapEventSource.dragStart,
    MapEventSource.onDrag,
    MapEventSource.dragEnd,
    MapEventSource.multiFingerGestureStart,
    MapEventSource.onMultiFinger,
    MapEventSource.multiFingerEnd,
    MapEventSource.flingAnimationController,
    MapEventSource.doubleTapZoomAnimationController,
    MapEventSource.scrollWheel,
    MapEventSource.cursorKeyboardRotation,
    MapEventSource.keyboard,
  };
}
