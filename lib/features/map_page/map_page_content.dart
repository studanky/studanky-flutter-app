import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_page/constants/map_page_constants.dart';
import 'package:studanky_flutter_app/features/map_page/providers/map_marker_provider.dart';
import 'package:studanky_flutter_app/features/map_page/providers/user_location_provider.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/marker.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_widget.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

class MapPageContent extends ConsumerStatefulWidget {
  const MapPageContent({super.key});

  @override
  ConsumerState<MapPageContent> createState() => _MapPageContentState();
}

class _MapPageContentState extends ConsumerState<MapPageContent> {
  // Default center (roughly the center of the Czech Republic) – used until /
  // unless the user's location is available.
  static const LatLng _initialCenter = LatLng(49.5630, 15.9398);
  static const double _defaultZoom = 14.5;

  final MapController _mapController = MapController();

  MapMarkerNotifier get _markerNotifier => ref.read(mapMarkerProvider.notifier);

  void _onMapReady() {
    _refreshMarkersForBounds(_mapController.camera.visibleBounds);
    unawaited(_centerOnUserLocation());
  }

  /// Requests permission and centers the map on the user's first fix. On
  /// failure it leaves the map at the default center and shows a subtle notice.
  Future<void> _centerOnUserLocation() async {
    final location = await ref.read(userLocationProvider.notifier).firstFix();

    if (!mounted) return;

    if (location != null) {
      _mapController.move(location, _defaultZoom);
      return;
    }

    _showLocationStatusMessage(ref.read(userLocationProvider).status);
  }

  void _showLocationStatusMessage(LocationStatus status) {
    final l10n = context.l10n;
    final (String message, VoidCallback? onAction)? feedback = switch (status) {
      LocationStatus.denied => (l10n.location_permission_denied, null),
      LocationStatus.deniedForever => (
        l10n.location_permission_denied_forever,
        Geolocator.openAppSettings,
      ),
      LocationStatus.serviceOff => (
        l10n.location_service_off,
        Geolocator.openLocationSettings,
      ),
      _ => null,
    };

    if (feedback == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(feedback.$1),
        action: feedback.$2 == null
            ? null
            : SnackBarAction(
                label: l10n.location_action_settings,
                onPressed: () => feedback.$2!(),
              ),
      ),
    );
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
    // Shared position and heading streams. With our own position stream only
    // the provider requests permission (not the layer itself), and our own
    // heading stream avoids the sensor error on devices without a compass.
    final locationNotifier = ref.watch(userLocationProvider.notifier);
    final positionStream = locationNotifier.positionStream;
    final headingStream = locationNotifier.headingStream;

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
                CurrentLocationLayer(
                  positionStream: positionStream,
                  headingStream: headingStream,
                ),
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
