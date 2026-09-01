import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/map_quick_zoom.dart';

// These tests belong to the temporary flutter_map#2246 workaround. When the
// upstream fix allows MapQuickZoom to be deleted, keep the user-facing
// regression scenarios (long second-tap hold, horizontal/diagonal locking,
// touch, mouse, and ordinary double tap) but run them against the native
// `InteractiveFlag.doubleTapDragZoom` integration instead.
void main() {
  const initialCenter = LatLng(49.8175, 15.4730);
  const initialZoom = 10.0;

  Future<MapController> pumpMap(WidgetTester tester) async {
    final controller = MapController();
    var quickZoomGestureActive = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => MapQuickZoom(
              controller: controller,
              minZoom: 5,
              maxZoom: 19,
              onGestureActiveChanged: (active) {
                if (quickZoomGestureActive == active) return;
                setState(() => quickZoomGestureActive = active);
              },
              child: FlutterMap(
                mapController: controller,
                options: MapOptions(
                  initialCenter: initialCenter,
                  initialZoom: initialZoom,
                  interactionOptions: InteractionOptions(
                    flags: quickZoomGestureActive
                        ? InteractiveFlag.doubleTapZoom
                        : InteractiveFlag.drag | InteractiveFlag.doubleTapZoom,
                  ),
                ),
                children: const [],
              ),
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
    Offset dragOffset = const Offset(0, 100),
  }) async {
    final controller = await pumpMap(tester);

    final mapCenter = tester.getCenter(find.byType(FlutterMap));
    final firstTap = await tester.startGesture(mapCenter, kind: kind);
    await firstTap.up();
    await tester.pump(const Duration(milliseconds: 50));

    final secondTap = await tester.startGesture(mapCenter, kind: kind);
    await tester.pump(secondTapHold);
    await secondTap.moveBy(dragOffset);
    await tester.pump();
    await secondTap.up();
    await tester.pumpAndSettle();
    final camera = controller.camera;
    final result = (center: camera.center, zoom: camera.zoom);
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
    return result;
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

  testWidgets('horizontal movement is captured without panning or zooming', (
    tester,
  ) async {
    final camera = await quickZoom(
      tester,
      PointerDeviceKind.touch,
      secondTapHold: const Duration(seconds: 1),
      // A real sideways drag is never perfectly horizontal; small Y jitter
      // must stay below the vertical activation threshold.
      dragOffset: const Offset(140, 5),
    );

    expect(camera.zoom, initialZoom);
    expect(camera.center, initialCenter);
  });

  testWidgets('diagonal movement uses only its vertical component', (
    tester,
  ) async {
    final vertical = await quickZoom(tester, PointerDeviceKind.touch);
    final diagonal = await quickZoom(
      tester,
      PointerDeviceKind.touch,
      dragOffset: const Offset(140, 100),
    );

    expect(diagonal.zoom, closeTo(vertical.zoom, 0.000001));
    expect(diagonal.center, initialCenter);
  });

  testWidgets('ordinary double tap still zooms in', (tester) async {
    final controller = await pumpMap(tester);
    final mapCenter = tester.getCenter(find.byType(FlutterMap));

    await tester.tapAt(mapCenter);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(mapCenter);
    await tester.pumpAndSettle();

    expect(controller.camera.zoom, greaterThan(initialZoom));
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
  });
}
