import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_camera_coordinator.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/map_view_config.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result_type.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

/// Translates a selected search result into a camera command and optional
/// spring-detail navigation event.
class MapSearchSelectionController {
  MapSearchSelectionController(this._camera, this._detailSheetInitialExtent);

  final MapCameraCoordinator _camera;
  final double _detailSheetInitialExtent;
  final Logger _logger = Logger('MapSearchSelectionController');
  int _selectionToken = 0;

  LatLng get origin => _camera.mapController.camera.center;

  Future<void> select(
    MapSearchResult result, {
    required double topInset,
    required double bottomInset,
    required ValueChanged<SpringMarkerEntity> onSpringSelected,
  }) async {
    final selectionToken = ++_selectionToken;
    final spring = result.spring;
    if (spring != null) {
      _logger.fine(
        'Spring search selected: ${spring.documentId} (${spring.name})',
      );
      await _camera.animateTo(
        center: _camera.detailFocusCenter(
          spring.position,
          topInset: topInset,
          zoom: MapViewConfig.springSearchZoom,
          sheetExtent: _detailSheetInitialExtent,
        ),
        zoom: MapViewConfig.springSearchZoom,
      );
      if (selectionToken == _selectionToken) onSpringSelected(spring);
      return;
    }

    final bounds = result.bounds;
    if (bounds != null && !bounds.isPoint) {
      final bottomOverlayLift = math.max(
        0.0,
        bottomInset - MapViewConfig.bottomLegalStripMinimumGap,
      );
      final fitted = CameraFit.bounds(
        bounds: LatLngBounds(bounds.southWest, bounds.northEast),
        padding: EdgeInsets.fromLTRB(48, 110, 48, 96 + bottomOverlayLift),
        maxZoom: MapViewConfig.searchMaxFitZoom,
      ).fit(_camera.mapController.camera);
      unawaited(_camera.animateTo(center: fitted.center, zoom: fitted.zoom));
      return;
    }

    unawaited(
      _camera.animateTo(
        center: result.position,
        zoom: _zoomForResultType(result.type),
      ),
    );
  }

  double _zoomForResultType(MapSearchResultType type) => switch (type) {
    MapSearchResultType.spring => MapViewConfig.springSearchZoom,
    MapSearchResultType.regional ||
    MapSearchResultType.regionalCountry ||
    MapSearchResultType.regionalRegion => 9,
    MapSearchResultType.regionalMunicipality ||
    MapSearchResultType.regionalMunicipalityPart => 12,
    MapSearchResultType.regionalStreet => 15,
    MapSearchResultType.regionalAddress || MapSearchResultType.poi => 16,
    MapSearchResultType.coordinate => 16,
    MapSearchResultType.other => 14,
  };
}
