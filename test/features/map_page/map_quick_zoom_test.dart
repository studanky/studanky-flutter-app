import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/map_quick_zoom.dart';

void main() {
  const initialCenter = LatLng(49.8175, 15.4730);
  const initialZoom = 10.0;

  Future<MapController> pumpMap(WidgetTester tester) async {
    final controller = MapController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MapQuickZoom(
            controller: controller,
            minZoom: 5,
            maxZoom: 19,
            child: FlutterMap(
              mapController: controller,
              options: const MapOptions(
                initialCenter: initialCenter,
                initialZoom: initialZoom,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.drag | InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: const [],
            ),
          ),
        ),
      ),
    );
    return controller;
  }

  Future<({LatLng center, double zoom})> quickZoom(
    WidgetTester tester,
    PointerDeviceKind kind, {
    Duration secondTapHold = const Duration(milliseconds: 50),
  }) async {
    final controller = await pumpMap(tester);

    final mapCenter = tester.getCenter(find.byType(FlutterMap));
    final firstTap = await tester.startGesture(mapCenter, kind: kind);
    await firstTap.up();
    await tester.pump(const Duration(milliseconds: 50));

    final secondTap = await tester.startGesture(mapCenter, kind: kind);
    await tester.pump(secondTapHold);
    await secondTap.moveBy(const Offset(0, 100));
    await tester.pump();
    await secondTap.up();
    await tester.pumpAndSettle();
    final camera = controller.camera;
    controller.dispose();
    return (center: camera.center, zoom: camera.zoom);
  }

  testWidgets('double-tap hold and drag zooms with touch', (tester) async {
    final camera = await quickZoom(tester, PointerDeviceKind.touch);

    expect(camera.zoom, greaterThan(initialZoom));
    expect(camera.center, initialCenter);
  });

  testWidgets('double-click hold and drag zooms with a mouse', (tester) async {
    final camera = await quickZoom(tester, PointerDeviceKind.mouse);

    expect(camera.zoom, greaterThan(initialZoom));
    expect(camera.center, initialCenter);
  });

  testWidgets('second tap may be held before dragging', (tester) async {
    final camera = await quickZoom(
      tester,
      PointerDeviceKind.mouse,
      secondTapHold: const Duration(seconds: 1),
    );

    expect(camera.zoom, greaterThan(initialZoom));
    expect(camera.center, initialCenter);
  });

  testWidgets('ordinary double tap still zooms in', (tester) async {
    final controller = await pumpMap(tester);
    final mapCenter = tester.getCenter(find.byType(FlutterMap));

    await tester.tapAt(mapCenter);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(mapCenter);
    await tester.pumpAndSettle();

    expect(controller.camera.zoom, greaterThan(initialZoom));
    controller.dispose();
  });
}
