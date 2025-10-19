import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map/providers/map_marker_providers.dart';
import 'package:studanky_flutter_app/features/map/widgets/marker.dart';

/// Displays the interactive map and renders markers managed by Riverpod.
class MapContent extends ConsumerStatefulWidget {
  const MapContent({super.key});

  @override
  ConsumerState<MapContent> createState() => _MapContentState();
}

class _MapContentState extends ConsumerState<MapContent> {
  static const LatLng _zdar = LatLng(49.5630, 15.9398);
  static const double _defaultZoom = 14.5;

  final MapController _mapController = MapController();

  MapMarkerNotifier get _markerNotifier =>
      ref.read(mapMarkerNotifierProvider.notifier);

  /// Triggers an initial marker load once the map is fully initialised.
  void _onMapReady() {
    _refreshMarkersForBounds(_mapController.camera.visibleBounds);
  }

  /// Reacts to camera changes and fetches markers for the new viewport.
  void _handleMapEvent(MapEvent event) {
    if (event is MapEventMoveEnd ||
        event is MapEventRotateEnd ||
        event is MapEventFlingAnimationEnd ||
        event is MapEventDoubleTapZoomEnd ||
        event is MapEventNonRotatedSizeChange) {
      _refreshMarkersForBounds(event.camera.visibleBounds);
    } else if (event is MapEventMove &&
        event.source == MapEventSource.mapController) {
      _refreshMarkersForBounds(event.camera.visibleBounds);
    }
  }

  /// Requests the notifier to ensure the current bounds are populated.
  void _refreshMarkersForBounds(LatLngBounds bounds) {
    unawaited(_markerNotifier.refreshVisibleBounds(bounds));
  }

  @override
  Widget build(BuildContext context) {
    final markerState = ref.watch(mapMarkerNotifierProvider);
    final markers = markerState.visibleMarkers
        .map(buildMarker)
        .toList(growable: false);

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _zdar,
                initialZoom: _defaultZoom,
                interactionOptions: const InteractionOptions(
                  flags:
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.pinchMove |
                      InteractiveFlag.doubleTapZoom |
                      InteractiveFlag.drag,
                ),
                onMapReady: _onMapReady,
                onMapEvent: _handleMapEvent,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapy.com/v1/maptiles/basic/256/{z}/{x}/{y}?apikey=U4_1WylUX52au77JaAJbXlLAGOCvrfCC1L1bVMwGIqQ',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
