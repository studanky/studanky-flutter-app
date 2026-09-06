import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/map_detail_focus.dart';

void main() {
  test('places the target midway in the safe strip above the sheet', () {
    const viewport = Size(400, 800);
    const target = LatLng(50.0755, 14.4378);
    const topInset = 24.0;
    const sheetExtent = 0.55;
    const downwardOffset = 24.0;
    final camera = MapCamera(
      crs: const Epsg3857(),
      center: target,
      zoom: 17,
      rotation: 0,
      nonRotatedSize: viewport,
    );

    final center = calculateMapDetailFocusCenter(
      camera: camera,
      target: target,
      topInset: topInset,
      sheetExtent: sheetExtent,
      downwardOffset: downwardOffset,
    );
    final focused = camera.withPosition(center: center);
    final targetOffset = focused.latLngToScreenOffset(target);
    final sheetTop =
        viewport.height - (viewport.height - topInset) * sheetExtent;
    final expectedY = (topInset + sheetTop) / 2 + downwardOffset;

    expect(targetOffset.dx, closeTo(viewport.width / 2, 0.001));
    expect(targetOffset.dy, closeTo(expectedY, 0.001));
  });

  test('keeps the screen-space target correct on a rotated map', () {
    const viewport = Size(430, 932);
    const target = LatLng(49.1951, 16.6068);
    final camera = MapCamera(
      crs: const Epsg3857(),
      center: const LatLng(50.0755, 14.4378),
      zoom: 14,
      rotation: 37,
      nonRotatedSize: viewport,
    );

    final center = calculateMapDetailFocusCenter(
      camera: camera,
      target: target,
      topInset: 47,
      sheetExtent: 0.5,
      downwardOffset: 24,
      zoom: 16,
    );
    final focused = camera.withPosition(center: center, zoom: 16);
    final targetOffset = focused.latLngToScreenOffset(target);
    final sheetTop = viewport.height - (viewport.height - 47) * 0.5;

    expect(targetOffset.dx, closeTo(viewport.width / 2, 0.001));
    expect(targetOffset.dy, closeTo((47 + sheetTop) / 2 + 24, 0.001));
  });
}
