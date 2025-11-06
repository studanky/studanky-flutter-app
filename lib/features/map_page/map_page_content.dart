import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_page/constants/map_page_constants.dart';
import 'package:studanky_flutter_app/features/map_page/providers/map_marker_provider.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/marker.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_widget.dart';

class MapPageContent extends ConsumerStatefulWidget {
  const MapPageContent({super.key});

  @override
  ConsumerState<MapPageContent> createState() => _MapPageContentState();
}

class _MapPageContentState extends ConsumerState<MapPageContent> {
  static const LatLng _initialCenter = LatLng(
    49.5630,
    15.9398,
  ); // TODO: ask for user's location
  static const double _defaultZoom = 14.5;

  final MapController _mapController = MapController();

  MapMarkerNotifier get _markerNotifier => ref.read(mapMarkerProvider.notifier);

  void _onMapReady() {
    _refreshMarkersForBounds(_mapController.camera.visibleBounds);
  }

  void _refreshMarkersForBounds(LatLngBounds bounds) {
    unawaited(_markerNotifier.refreshVisibleBounds(bounds));
  }

  void _onSearchResultSelected(MapSearchResult result) {
    if (!mounted) return;

    FocusScope.of(context).unfocus();
    final currentZoom = _mapController.camera.zoom;
    final targetZoom = currentZoom < 15.0 ? 15.0 : currentZoom;
    _mapController.move(result.position, targetZoom);
  }

  @override
  Widget build(BuildContext context) {
    final markerState = ref.watch(mapMarkerProvider);
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
                initialCenter: _initialCenter,
                initialZoom: _defaultZoom,
                onMapReady: _onMapReady,
                interactionOptions: const InteractionOptions(
                  flags:
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.pinchMove |
                      InteractiveFlag.doubleTapZoom |
                      InteractiveFlag.drag,
                ),
              ),
              children: [
                TileLayer(urlTemplate: MapPageConstants.mapTilesMapy),
                MarkerLayer(markers: markers),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).padding.top + 12,
            child: MapSearchWidget(
              hintText: 'Hledejte...',
              onResultSelected: _onSearchResultSelected,
            ),
          ),
        ],
      ),
    );
  }
}
