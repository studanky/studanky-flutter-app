import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_camera_commands.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_search_selection_controller.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result_type.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';

class _FakeCameraCommands implements MapCameraCommands {
  _FakeCameraCommands({this.animationGate});

  final Future<void>? animationGate;
  final List<({LatLng? center, double? zoom, double? rotation})> animations =
      [];
  LatLng focusedCenter = const LatLng(49, 15);

  @override
  final MapCamera currentCamera = MapCamera(
    crs: const Epsg3857(),
    center: const LatLng(50, 14),
    zoom: 12,
    rotation: 0,
    nonRotatedSize: const Size(400, 800),
  );

  @override
  Future<void> animateTo({
    LatLng? center,
    double? zoom,
    double? rotation,
  }) async {
    animations.add((center: center, zoom: zoom, rotation: rotation));
    final gate = animationGate;
    if (gate != null) await gate;
  }

  @override
  LatLng detailFocusCenter(
    LatLng target, {
    required double topInset,
    double? zoom,
    double? sheetExtent,
  }) => focusedCenter;
}

SpringMarkerEntity _spring(String id) => SpringMarkerEntity(
  documentId: id,
  name: id,
  position: const LatLng(50.1, 14.4),
  status: SpringStatus.unknown,
);

MapSearchResult _springResult(SpringMarkerEntity spring) => MapSearchResult(
  label: spring.name,
  position: spring.position,
  type: MapSearchResultType.spring,
  spring: spring,
);

void main() {
  test('spring selection focuses before opening the detail', () async {
    final camera = _FakeCameraCommands();
    final controller = MapSearchSelectionController(camera, 0.5);
    final spring = _spring('spring-a');
    SpringMarkerEntity? selected;

    await controller.select(
      _springResult(spring),
      topInset: 24,
      bottomInset: 34,
      onSpringSelected: (value) => selected = value,
    );

    expect(camera.animations.single.center, camera.focusedCenter);
    expect(camera.animations.single.zoom, 17);
    expect(selected, spring);
  });

  test('a superseded spring selection cannot open stale detail', () async {
    final gate = Completer<void>();
    final camera = _FakeCameraCommands(animationGate: gate.future);
    final controller = MapSearchSelectionController(camera, 0.5);
    final selected = <String>[];

    final first = controller.select(
      _springResult(_spring('first')),
      topInset: 24,
      bottomInset: 34,
      onSpringSelected: (spring) => selected.add(spring.documentId),
    );
    final second = controller.select(
      _springResult(_spring('second')),
      topInset: 24,
      bottomInset: 34,
      onSpringSelected: (spring) => selected.add(spring.documentId),
    );
    gate.complete();
    await Future.wait([first, second]);

    expect(selected, ['second']);
  });
}
