import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/map_view_config.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/dark_map_tile_filter.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/map_quick_zoom.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/map_tile_layer.dart';

/// Full-bleed map surface. All state and commands are supplied by its owner.
class MapCanvas extends StatelessWidget {
  const MapCanvas({
    required this.controller,
    required this.quickZoomGestureActive,
    required this.markerLayer,
    required this.backgroundColor,
    required this.isDarkMode,
    required this.locationActivated,
    required this.positionStream,
    required this.headingStream,
    required this.onMapReady,
    required this.onMapEvent,
    required this.onMapTap,
    required this.onZoomStart,
    required this.onQuickZoomGestureActiveChanged,
    super.key,
  });

  final MapController controller;
  final ValueListenable<bool> quickZoomGestureActive;
  final Widget markerLayer;
  final Color backgroundColor;
  final bool isDarkMode;
  final bool locationActivated;
  final Stream<LocationMarkerPosition?> positionStream;
  final Stream<LocationMarkerHeading?> headingStream;
  final VoidCallback onMapReady;
  final ValueChanged<MapEvent> onMapEvent;
  final VoidCallback onMapTap;
  final VoidCallback onZoomStart;
  final ValueChanged<bool> onQuickZoomGestureActiveChanged;

  @override
  Widget build(BuildContext context) {
    // The quick-zoom notifier only changes interaction flags. Keep the layer
    // widget identities outside its builder so toggling a gesture does not
    // reconstruct tile, location, or marker configuration.
    final mapLayers = <Widget>[
      if (isDarkMode)
        DarkMapTileFilter(child: buildMapTileLayer())
      else
        buildMapTileLayer(),
      if (locationActivated)
        CurrentLocationLayer(
          positionStream: positionStream,
          headingStream: headingStream,
        ),
      markerLayer,
    ];

    return MapQuickZoom(
      controller: controller,
      minZoom: MapViewConfig.minZoom,
      maxZoom: MapViewConfig.maxZoom,
      onZoomStart: onZoomStart,
      onGestureActiveChanged: onQuickZoomGestureActiveChanged,
      child: ValueListenableBuilder<bool>(
        valueListenable: quickZoomGestureActive,
        builder: (context, quickZoomActive, _) => FlutterMap(
          mapController: controller,
          options: MapOptions(
            initialCenter: MapViewConfig.initialCenter,
            initialZoom: MapViewConfig.defaultZoom,
            minZoom: MapViewConfig.minZoom,
            maxZoom: MapViewConfig.maxZoom,
            backgroundColor: backgroundColor,
            onMapReady: onMapReady,
            onMapEvent: onMapEvent,
            onTap: (_, _) => onMapTap(),
            interactionOptions: InteractionOptions(
              flags: quickZoomActive
                  ? MapViewConfig.interactionFlags & ~InteractiveFlag.drag
                  : MapViewConfig.interactionFlags,
              enableMultiFingerGestureRace: true,
              pinchZoomThreshold: MapViewConfig.pinchZoomGestureThreshold,
              rotationThreshold: MapViewConfig.rotationGestureThresholdDegrees,
              pinchZoomWinGestures: MapViewConfig.pinchGestureWinGestures,
              pinchMoveWinGestures: MapViewConfig.pinchGestureWinGestures,
              rotationWinGestures: MultiFingerGesture.rotate,
            ),
          ),
          children: mapLayers,
        ),
      ),
    );
  }
}
