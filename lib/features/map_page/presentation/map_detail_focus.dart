import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Calculates the camera center that places [target] in the visible strip
/// above an open bottom sheet.
///
/// The sheet height is measured inside the safe-area viewport:
///
/// `sheetTop = h - (h - topInset) * sheetExtent`
///
/// The target belongs halfway between [topInset] and `sheetTop`, with a small
/// visual offset. [MapCamera.screenOffsetToLatLng] keeps this correct for a
/// rotated map as well.
LatLng calculateMapDetailFocusCenter({
  required MapCamera camera,
  required LatLng target,
  required double topInset,
  required double sheetExtent,
  required double downwardOffset,
  double? zoom,
}) {
  final onTarget = camera.withPosition(center: target, zoom: zoom);
  final size = onTarget.nonRotatedSize;
  final extent = sheetExtent.clamp(0.0, 1.0).toDouble();
  final shift =
      ((size.height - topInset) * extent - topInset) / 2 - downwardOffset;
  return onTarget.screenOffsetToLatLng(
    size.center(Offset.zero) + Offset(0, shift),
  );
}
