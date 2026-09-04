import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/haptics/haptics.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_cluster_item.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/map_view_config.dart';
import 'package:studanky_flutter_app/features/map_page/utils/map_camera_animator.dart';

typedef MapCompassState = ({double rotationRad, bool centered});

/// Owns map-camera feedback and camera commands used by the map view.
class MapCameraCoordinator {
  MapCameraCoordinator({
    required TickerProvider vsync,
    required double initialDetailSheetExtent,
  }) : _detailSheetExtent = initialDetailSheetExtent,
       _animator = MapCameraAnimator(
         mapController: MapController(),
         vsync: vsync,
       ) {
    mapController = _animator.mapController;
  }

  late final MapController mapController;
  final MapCameraAnimator _animator;
  final compass = ValueNotifier<MapCompassState>((
    rotationRad: 0,
    centered: false,
  ));
  final zoom = ValueNotifier<double>(MapViewConfig.defaultZoom);
  final quickZoomGestureActive = ValueNotifier<bool>(false);

  int? _lastZoomDetent;
  double _detailSheetExtent;

  Future<void> animateTo({LatLng? center, double? zoom, double? rotation}) =>
      _animator.animateTo(center: center, zoom: zoom, rotation: rotation);

  void setQuickZoomGestureActive(bool active) {
    quickZoomGestureActive.value = active;
  }

  void updateFeedback(LatLng? userPosition) {
    final camera = mapController.camera;
    final centered =
        userPosition != null &&
        const Distance().as(LengthUnit.Meter, camera.center, userPosition) <
            MapViewConfig.centeredThresholdMeters;

    compass.value = (
      rotationRad: camera.rotation * math.pi / 180,
      centered: centered,
    );
    zoom.value = camera.zoom;
  }

  void changeZoom(double value) {
    final clamped = value.clamp(MapViewConfig.minZoom, MapViewConfig.maxZoom);
    const detentStep = 0.5;
    final detent = (clamped / detentStep).round();
    if (detent != _lastZoomDetent) {
      _lastZoomDetent = detent;
      Haptics.selection();
    }
    mapController.move(mapController.camera.center, clamped);
  }

  void stepZoom(double delta) {
    final target = (mapController.camera.zoom + delta).clamp(
      MapViewConfig.minZoom,
      MapViewConfig.maxZoom,
    );
    unawaited(animateTo(zoom: target));
  }

  bool resetNorthIfNeeded() {
    final rotation = mapController.camera.rotation % 360;
    final fromNorth = rotation > 180 ? rotation - 360 : rotation;
    if (fromNorth.abs() <= MapViewConfig.northEpsilonDegrees) return false;
    unawaited(animateTo(rotation: 0));
    return true;
  }

  void moveToUser(LatLng location) {
    final currentZoom = mapController.camera.zoom;
    final targetZoom = currentZoom < MapViewConfig.recenterMinZoom
        ? MapViewConfig.recenterMinZoom
        : currentZoom;
    unawaited(animateTo(center: location, zoom: targetZoom));
  }

  void moveDirect(LatLng location, double zoom) {
    mapController.move(location, zoom);
  }

  void expandCluster(
    Cluster cluster, {
    required bool detailOpen,
    required double topInset,
  }) {
    final targetZoom =
        (cluster.expansionZoom + MapViewConfig.clusterExpandZoomBoost)
            .clamp(MapViewConfig.minZoom, MapViewConfig.maxZoom)
            .toDouble();
    final targetCenter = detailOpen
        ? detailFocusCenter(
            cluster.position,
            topInset: topInset,
            zoom: targetZoom,
          )
        : cluster.position;
    unawaited(animateTo(center: targetCenter, zoom: targetZoom));
  }

  LatLng detailFocusCenter(
    LatLng target, {
    required double topInset,
    double? zoom,
    double? sheetExtent,
  }) {
    final onTarget = mapController.camera.withPosition(
      center: target,
      zoom: zoom,
    );
    final size = onTarget.nonRotatedSize;
    final extent = (sheetExtent ?? _detailSheetExtent)
        .clamp(0.0, 1.0)
        .toDouble();
    final shift =
        ((size.height - topInset) * extent - topInset) / 2 -
        MapViewConfig.detailFocusDownwardOffset;
    return onTarget.screenOffsetToLatLng(
      size.center(Offset.zero) + Offset(0, shift),
    );
  }

  void updateDetailSheetExtent(double extent) {
    _detailSheetExtent = extent.clamp(0.0, 1.0).toDouble();
  }

  void dispose() {
    _animator.dispose();
    compass.dispose();
    zoom.dispose();
    quickZoomGestureActive.dispose();
  }
}
