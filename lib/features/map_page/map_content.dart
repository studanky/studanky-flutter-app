import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_page/map_page_constants/map_page_constants.dart';
import 'package:studanky_flutter_app/features/map_page/providers/map_marker_providers.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/marker.dart';
import 'package:studanky_flutter_app/features/map_search/models/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_providers.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_overlay.dart';

/// Displays the interactive map and renders markers managed by Riverpod.
class MapContent extends ConsumerStatefulWidget {
  const MapContent({super.key});

  @override
  ConsumerState<MapContent> createState() => _MapContentState();
}

class _MapContentState extends ConsumerState<MapContent> {
  static const LatLng _zdar = LatLng(
    49.5630,
    15.9398,
  ); // Random initial location - will be chagned later
  static const double _defaultZoom = 14.5;

  final MapController _mapController = MapController();
  late final TextEditingController _searchController;

  MapMarkerNotifier get _markerNotifier =>
      ref.read(mapMarkerNotifierProvider.notifier);

  MapSearchNotifier get _searchNotifier =>
      ref.read(mapSearchNotifierProvider.notifier);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Triggers an initial marker load once the map is fully initialised.
  void _onMapReady() {
    _refreshMarkersForBounds(_mapController.camera.visibleBounds);
  }

  /// Requests the notifier to ensure the current bounds are populated.
  void _refreshMarkersForBounds(LatLngBounds bounds) {
    unawaited(_markerNotifier.refreshVisibleBounds(bounds));
  }

  void _onSearchResultSelected(MapSearchResult result) {
    _searchNotifier.select(result);
    if (mounted) {
      FocusScope.of(context).unfocus();
    }
    final currentZoom = _mapController.camera.zoom;
    final targetZoom = currentZoom < 15.0 ? 15.0 : currentZoom;
    _mapController.move(result.position, targetZoom);
  }

  @override
  Widget build(BuildContext context) {
    final markerState = ref.watch(mapMarkerNotifierProvider);
    final markers = markerState.visibleMarkers
        .map(buildMarker)
        .toList(growable: false);
    final searchState = ref.watch(mapSearchNotifierProvider);

    if (_searchController.text != searchState.query) {
      _searchController.value = TextEditingValue(
        text: searchState.query,
        selection: TextSelection.collapsed(offset: searchState.query.length),
      );
    }

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
            child: MapSearchOverlay(
              controller: _searchController,
              state: searchState,
              onQueryChanged: _searchNotifier.setQuery,
              onClear: _searchNotifier.clear,
              onResultTap: _onSearchResultSelected,
            ),
          ),
        ],
      ),
    );
  }
}
