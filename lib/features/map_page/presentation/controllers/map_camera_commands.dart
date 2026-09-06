import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Narrow camera boundary used by presentation controllers that issue map
/// movements but do not own the concrete flutter_map controller.
abstract interface class MapCameraCommands {
  MapCamera get currentCamera;

  Future<void> animateTo({LatLng? center, double? zoom, double? rotation});

  LatLng detailFocusCenter(
    LatLng target, {
    required double topInset,
    double? zoom,
    double? sheetExtent,
  });
}
