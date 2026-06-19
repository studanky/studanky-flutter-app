import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/core/haptics/haptics.dart';
import 'package:studanky_flutter_app/core/widgets/app_progress_indicator.dart';
import 'package:studanky_flutter_app/core/widgets/glass_snack_bar.dart';
import 'package:studanky_flutter_app/features/favorites/providers/favorites_provider.dart';
import 'package:studanky_flutter_app/features/favorites/widgets/favorites_dialog.dart';
import 'package:studanky_flutter_app/features/map_page/constants/map_page_constants.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_cluster_item.dart';
import 'package:studanky_flutter_app/features/map_page/providers/map_marker_provider.dart';
import 'package:studanky_flutter_app/features/map_page/providers/user_location_provider.dart';
import 'package:studanky_flutter_app/features/map_page/utils/map_camera_animator.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/about_dialog.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/cluster_marker.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/disclaimer_dialog.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/map_attribution.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/map_control_stack.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/map_disclaimer.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/map_empty_state.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/map_zoom_slider.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/marker.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/status_bar_scrim.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result_type.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_provider.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_widget.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/spring_detail_sheet.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

class MapPageContent extends ConsumerStatefulWidget {
  const MapPageContent({super.key});

  @override
  ConsumerState<MapPageContent> createState() => _MapPageContentState();
}

/// Localized status word for a marker's screen-reader label. Reuses the detail
/// sheet's flow labels; "stale" gets its own word so it isn't conflated with
/// "unknown".
String _statusLabelFor(SpringIcon icon, AppLocalizations l10n) =>
    switch (icon) {
      SpringIcon.flowing => l10n.spring_detail_status_flowing,
      SpringIcon.notFlowing => l10n.spring_detail_status_not_flowing,
      SpringIcon.stale => l10n.map_status_stale,
      SpringIcon.unknown => l10n.spring_detail_status_unknown,
    };

enum _MapEmptyOverlayMode { hidden, empty, refreshing }

class _MapPageContentState extends ConsumerState<MapPageContent>
    with SingleTickerProviderStateMixin {
  // Default center (roughly the center of the Czech Republic) – used until /
  // unless the user's location is available.
  static const LatLng _initialCenter = LatLng(49.5630, 15.9398);
  static const double _defaultZoom = 14.5;

  /// Camera zoom bounds; also the range the vertical zoom slider maps onto.
  static const double _minZoom = 5;
  static const double _maxZoom = 19;

  /// Extra zoom added on top of a cluster's [Cluster.expansionZoom] so tapping
  /// a cluster zooms in just enough for its points to spread out while keeping
  /// the surrounding context in view — not so far that the split happens off
  /// near the map edges or out of sight.
  static const double _clusterExpandZoomBoost = 1.5;

  /// When recentering on the user, never stay zoomed further out than this so
  /// the location dot is comfortably in view.
  static const double _recenterMinZoom = 15.0;

  /// Search-selected springs should open close enough for the selected marker
  /// to be unambiguous before the detail sheet appears.
  static const double _springSearchZoom = 17.0;

  /// Map center within this many metres of the user's fix counts as "centered".
  static const double _centeredThresholdMeters = 25;

  /// Map rotation (degrees) below which north is treated as "up".
  static const double _northEpsilonDegrees = 1.0;

  /// Don't zoom in closer than this when fitting a search result's extent, so a
  /// tiny address bbox still lands at a sensible street-level zoom.
  static const double _searchMaxFitZoom = 16;

  static const int _mapInteractionFlags =
      InteractiveFlag.pinchZoom |
      InteractiveFlag.pinchMove |
      InteractiveFlag.doubleTapZoom |
      InteractiveFlag.drag |
      InteractiveFlag.rotate;

  /// Multi-touch gestures are locked to the first intentional gesture. A pinch
  /// may still pan around its focal point, but it cannot start rotating later.
  static const int _pinchGestureWinGestures =
      MultiFingerGesture.pinchZoom | MultiFingerGesture.pinchMove;
  static const double _pinchZoomGestureThreshold = 0.12;
  static const double _rotationGestureThresholdDegrees = 20.0;

  /// Map event sources that mean the *user* moved the map (vs. our own
  /// programmatic [MapEventSource.mapController] animations). Used to clear the
  /// search once the user takes over the camera.
  static const Set<MapEventSource> _userMoveSources = {
    MapEventSource.dragStart,
    MapEventSource.onDrag,
    MapEventSource.dragEnd,
    MapEventSource.multiFingerGestureStart,
    MapEventSource.onMultiFinger,
    MapEventSource.multiFingerEnd,
    MapEventSource.flingAnimationController,
    MapEventSource.doubleTapZoomAnimationController,
    MapEventSource.scrollWheel,
    MapEventSource.cursorKeyboardRotation,
    MapEventSource.keyboard,
  };

  /// Coalesce rapid pan/zoom events into one fetch once the map goes idle
  /// (api-reference.md §3.1). Reclustering itself runs inside the notifier.
  static const Duration _cameraDebounce = Duration(milliseconds: 300);

  /// Empty-map messaging should feel settled, not blink during camera motion or
  /// rapid fetch/status transitions.
  static const Duration _emptyStateRevealDelay = Duration(milliseconds: 450);
  static const Duration _emptyStateFadeDuration = Duration(milliseconds: 240);

  final MapController _mapController = MapController();
  final Logger _logger = Logger('MapPageContent');
  Timer? _cameraDebounceTimer;
  Timer? _emptyStateRevealTimer;

  /// True while a tap on the "my location" button is waiting for the first fix.
  bool _isLocating = false;
  bool _isMapReady = false;
  _MapEmptyOverlayMode _mapEmptyOverlayMode = _MapEmptyOverlayMode.hidden;
  int _searchSelectionToken = 0;

  /// Last integer zoom level a slider-drag haptic fired at, so the continuous
  /// drag ticks once per crossed level (a detent) instead of every frame.
  int? _lastZoomDetent;

  /// Live map orientation + centered state for the compass/location button.
  /// Kept in a [ValueNotifier] so map rotation repaints only the button, never
  /// the whole map.
  final ValueNotifier<({double rotationRad, bool centered})> _compass =
      ValueNotifier((rotationRad: 0, centered: false));

  /// Live camera zoom, kept separate so the zoom slider repaints on its own
  /// without rebuilding the whole map.
  final ValueNotifier<double> _zoom = ValueNotifier(_defaultZoom);

  late final MapCameraAnimator _animator = MapCameraAnimator(
    mapController: _mapController,
    vsync: this,
  );

  MapMarkerNotifier get _markerNotifier => ref.read(mapMarkerProvider.notifier);

  @override
  void dispose() {
    _cameraDebounceTimer?.cancel();
    _emptyStateRevealTimer?.cancel();
    _animator.dispose();
    _compass.dispose();
    _zoom.dispose();
    super.dispose();
  }

  void _onMapReady() {
    _isMapReady = true;
    // First load is immediate; subsequent camera changes are debounced.
    _emitCamera();
    _updateCompass();
    unawaited(_centerOnUserLocation());
  }

  void _onMapEvent(MapEvent event) {
    // Orientation/centered feedback must be live (every frame of a rotate or
    // pan), so update it immediately; only the marker fetch is debounced.
    _updateCompass();
    _markMapEmptyStateRefreshing();
    if (_userMoveSources.contains(event.source)) {
      _clearSearchOnUserMove();
    }
    _cameraDebounceTimer?.cancel();
    _cameraDebounceTimer = Timer(_cameraDebounce, _emitCamera);
  }

  /// Once the user moves the map themselves (e.g. after we animated to a search
  /// result), the stale search query/results are cleared. Programmatic camera
  /// changes use [MapEventSource.mapController] and are intentionally excluded.
  void _clearSearchOnUserMove() {
    final provider = mapSearchProvider(
      Localizations.localeOf(context).languageCode,
    );
    if (ref.read(provider).query.isEmpty) return;
    ref.read(provider.notifier).clear();
  }

  void _updateCompass() {
    if (!mounted) return;
    final camera = _mapController.camera;
    final user = ref.read(userLocationProvider.notifier).lastKnownPosition;
    final centered =
        user != null &&
        const Distance().as(LengthUnit.Meter, camera.center, user) <
            _centeredThresholdMeters;

    _compass.value = (
      rotationRad: camera.rotation * math.pi / 180,
      centered: centered,
    );
    _zoom.value = camera.zoom;
  }

  /// Jumps the camera to a slider-selected [zoom] (continuous drag), keeping
  /// the current centre. The resulting map event refreshes the slider.
  void _onZoomChanged(double zoom) {
    final clamped = zoom.clamp(_minZoom, _maxZoom);
    // Tick once each time the drag crosses an integer zoom level, so the slider
    // notches like a physical detent instead of buzzing on every frame.
    final detent = clamped.round();
    if (detent != _lastZoomDetent) {
      _lastZoomDetent = detent;
      Haptics.selection();
    }
    _mapController.move(_mapController.camera.center, clamped);
  }

  /// Animated stepped zoom from the slider's +/- buttons.
  void _onZoomStep(double delta) {
    final target = (_mapController.camera.zoom + delta).clamp(
      _minZoom,
      _maxZoom,
    );
    unawaited(_animator.animateTo(zoom: target));
  }

  void _emitCamera() {
    if (!mounted) return;
    final camera = _mapController.camera;
    unawaited(
      _markerNotifier
          .onCameraChanged(camera.visibleBounds, camera.zoom)
          .whenComplete(() {
            if (!mounted) return;
            _syncMapEmptyState(ref.read(mapMarkerProvider));
          }),
    );
  }

  bool _isEmptyStateEligible(MapMarkerState state) =>
      state.visibleBoundsLoaded &&
      state.items.isEmpty &&
      !state.status.isLoading &&
      !state.status.hasError;

  bool get _isMapEmptyOverlayVisible =>
      _mapEmptyOverlayMode != _MapEmptyOverlayMode.hidden;

  void _syncMapEmptyState(MapMarkerState state) {
    _emptyStateRevealTimer?.cancel();

    if (state.items.isNotEmpty) {
      _setMapEmptyOverlayMode(_MapEmptyOverlayMode.hidden);
      return;
    }

    if (state.status.isLoading || !state.visibleBoundsLoaded) {
      if (_isMapEmptyOverlayVisible) {
        _setMapEmptyOverlayMode(_MapEmptyOverlayMode.refreshing);
      }
      return;
    }

    if (state.status.hasError) {
      if (_isMapEmptyOverlayVisible) {
        _setMapEmptyOverlayMode(_MapEmptyOverlayMode.empty);
      }
      return;
    }

    if (!_isEmptyStateEligible(state)) {
      _setMapEmptyOverlayMode(_MapEmptyOverlayMode.hidden);
      return;
    }

    if (_isMapEmptyOverlayVisible) {
      _setMapEmptyOverlayMode(_MapEmptyOverlayMode.empty);
      return;
    }

    _emptyStateRevealTimer = Timer(_emptyStateRevealDelay, () {
      if (!mounted || !_isEmptyStateEligible(ref.read(mapMarkerProvider))) {
        return;
      }
      _setMapEmptyOverlayMode(_MapEmptyOverlayMode.empty);
    });
  }

  void _markMapEmptyStateRefreshing() {
    _emptyStateRevealTimer?.cancel();
    if (!_isMapEmptyOverlayVisible) return;
    _setMapEmptyOverlayMode(_MapEmptyOverlayMode.refreshing);
  }

  void _setMapEmptyOverlayMode(_MapEmptyOverlayMode mode) {
    if (!mounted || _mapEmptyOverlayMode == mode) return;
    setState(() => _mapEmptyOverlayMode = mode);
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

    showGlassSnackBar(
      context,
      message: feedback.$1,
      actionLabel: feedback.$2 == null ? null : l10n.location_action_settings,
      onAction: feedback.$2,
    );
  }

  /// Combined compass + location control (mapy.com style):
  /// 1. if the map is rotated, the first tap snaps north back to up;
  /// 2. once north is up, the tap recenters on the user.
  void _onLocationButtonTap() {
    // Normalise to (−180, 180] so a rotation near a full turn still reads as
    // "north up" and we never reset by a hair.
    final rotation = _mapController.camera.rotation % 360;
    final fromNorth = rotation > 180 ? rotation - 360 : rotation;

    if (fromNorth.abs() > _northEpsilonDegrees) {
      Haptics.selection();
      unawaited(_animator.animateTo(rotation: 0));
      return;
    }
    unawaited(_recenterOnUser());
  }

  /// Recenters the map on the user. Uses the last known fix for an instant
  /// response, otherwise acquires one (driving the permission flow on first
  /// use) and falls back to a status message if the location is unavailable.
  Future<void> _recenterOnUser() async {
    if (_isLocating) return;
    Haptics.tap();

    final notifier = ref.read(userLocationProvider.notifier);

    final last = notifier.lastKnownPosition;
    if (last != null) {
      _moveToUser(last);
      return;
    }

    setState(() => _isLocating = true);
    final location = await notifier.firstFix();
    if (!mounted) return;
    setState(() => _isLocating = false);

    if (location != null) {
      _moveToUser(location);
      return;
    }

    _showLocationStatusMessage(ref.read(userLocationProvider).status);
  }

  void _moveToUser(LatLng location) {
    final currentZoom = _mapController.camera.zoom;
    final targetZoom = currentZoom < _recenterMinZoom
        ? _recenterMinZoom
        : currentZoom;
    // Animated recenter; each tick emits a map event that refreshes the
    // compass and (debounced) marker fetch.
    unawaited(_animator.animateTo(center: location, zoom: targetZoom));
  }

  void _onClusterTap(Cluster cluster) {
    Haptics.selection();
    // [expansionZoom] is only the level at which the cluster *starts* to break
    // apart — landing exactly there leaves the points still cramped. Push a few
    // levels closer (clamped to the max) so the children spread out with room
    // to read them, centred on the cluster.
    final targetZoom = (cluster.expansionZoom + _clusterExpandZoomBoost).clamp(
      _minZoom,
      _maxZoom,
    );
    unawaited(_animator.animateTo(center: cluster.position, zoom: targetZoom));
  }

  void _onSpringTap(SpringMarkerEntity spring) {
    Haptics.tap();
    _logger.fine('Spring tapped: ${spring.documentId} (${spring.name})');
    FocusScope.of(context).unfocus();
    unawaited(showSpringDetailSheet(context, marker: spring));
  }

  /// Opens the favourites popup; if the user picks one, animate-centers the map
  /// on it and opens its detail.
  Future<void> _openFavorites() async {
    Haptics.tap();
    FocusScope.of(context).unfocus();
    final selected = await showFavoritesDialog(context);
    if (selected == null || !mounted) return;

    unawaited(
      _animator.animateTo(center: selected.position, zoom: _recenterMinZoom),
    );
    unawaited(showSpringDetailSheet(context, marker: selected));
  }

  void _onSearchResultSelected(MapSearchResult result) {
    unawaited(_handleSearchResultSelected(result));
  }

  Future<void> _handleSearchResultSelected(MapSearchResult result) async {
    if (!mounted) return;
    FocusScope.of(context).unfocus();

    final selectionToken = ++_searchSelectionToken;
    final spring = result.spring;
    if (spring != null) {
      _logger.fine(
        'Spring search selected: ${spring.documentId} (${spring.name})',
      );
      await _animator.animateTo(
        center: spring.position,
        zoom: _springSearchZoom,
      );
      if (!mounted || selectionToken != _searchSelectionToken) return;
      unawaited(showSpringDetailSheet(context, marker: spring));
      return;
    }

    final bounds = result.bounds;
    if (bounds != null && !bounds.isPoint) {
      // Fit the whole locality in view, leaving room for the overlay controls
      // (search bar on top, buttons + attribution at the bottom), then animate
      // to the resulting camera.
      final fitted = CameraFit.bounds(
        bounds: LatLngBounds(bounds.southWest, bounds.northEast),
        padding: const EdgeInsets.fromLTRB(48, 110, 48, 96),
        maxZoom: _searchMaxFitZoom,
      ).fit(_mapController.camera);
      unawaited(_animator.animateTo(center: fitted.center, zoom: fitted.zoom));
      return;
    }

    // No usable extent (e.g. a coordinate): centre on the point at a zoom
    // sensible for the result type.
    unawaited(
      _animator.animateTo(
        center: result.position,
        zoom: _zoomForResultType(result.type),
      ),
    );
  }

  LatLng? _searchOrigin() {
    if (!_isMapReady) return null;
    return _mapController.camera.center;
  }

  double _zoomForResultType(MapSearchResultType type) => switch (type) {
    MapSearchResultType.spring => _springSearchZoom,
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

  @override
  Widget build(BuildContext context) {
    ref.listen<MapMarkerState>(mapMarkerProvider, (_, next) {
      _syncMapEmptyState(next);
    });

    final markerState = ref.watch(mapMarkerProvider);
    final config = ref.watch(platformConfigControllerProvider);
    final locationStatus = ref.watch(userLocationProvider).status;
    final favoritesCount = ref.watch(
      favoritesControllerProvider.select((favorites) => favorites.length),
    );
    final l10n = context.l10n;
    final isMapEmptyOverlayVisible = _isMapEmptyOverlayVisible;
    final isMapEmptyOverlayRefreshing =
        _mapEmptyOverlayMode == _MapEmptyOverlayMode.refreshing;

    final markers = <Marker>[
      for (final item in markerState.items)
        switch (item) {
          Cluster() => buildClusterMarker(
            item,
            onTap: () => _onClusterTap(item),
            semanticsLabel: l10n.map_cluster_semantic(item.count),
          ),
          SpringPoint(:final spring) => buildSpringMarker(
            spring,
            config.iconFor(spring.status.wireValue, spring.statusUpdatedAt),
            onTap: () => _onSpringTap(spring),
            semanticsLabel: l10n.map_marker_semantic(
              spring.name,
              _statusLabelFor(
                config.iconFor(spring.status.wireValue, spring.statusUpdatedAt),
                l10n,
              ),
            ),
          ),
        },
    ];

    // Shared position and heading streams. With our own position stream only
    // the provider requests permission (not the layer itself), and our own
    // heading stream avoids the sensor error on devices without a compass.
    final locationNotifier = ref.watch(userLocationProvider.notifier);
    final positionStream = locationNotifier.positionStream;
    final headingStream = locationNotifier.headingStream;

    // Mapy.com serves no dark map set, so in dark mode we apply an invert +
    // hue-rotate colour filter over the raster tiles only (not our markers or
    // the location dot). Follows the app theme's brightness, so it tracks both
    // the system setting and any future manual light/dark toggle.
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final content = SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _initialCenter,
                initialZoom: _defaultZoom,
                minZoom: _minZoom,
                maxZoom: _maxZoom,
                onMapReady: _onMapReady,
                onMapEvent: _onMapEvent,
                interactionOptions: const InteractionOptions(
                  flags: _mapInteractionFlags,
                  enableMultiFingerGestureRace: true,
                  pinchZoomThreshold: _pinchZoomGestureThreshold,
                  rotationThreshold: _rotationGestureThresholdDegrees,
                  pinchZoomWinGestures: _pinchGestureWinGestures,
                  pinchMoveWinGestures: _pinchGestureWinGestures,
                  rotationWinGestures: MultiFingerGesture.rotate,
                ),
              ),
              children: [
                if (isDarkMode)
                  darkModeTilesContainerBuilder(
                    context,
                    TileLayer(urlTemplate: MapPageConstants.mapTilesMapy),
                  )
                else
                  TileLayer(urlTemplate: MapPageConstants.mapTilesMapy),
                CurrentLocationLayer(
                  positionStream: positionStream,
                  headingStream: headingStream,
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          ),
          // Permanent frosted strip behind the OS status bar so the system
          // clock/indicators stay legible over the full-bleed map.
          const Positioned(top: 0, left: 0, right: 0, child: StatusBarScrim()),
          // The zoom slider intentionally ignores horizontal safe-area insets:
          // its centre line must sit on the viewport's right edge. The inner
          // stack clips the outside half, so the thumb reads as a semicircle
          // without producing layout overflow.
          Positioned.fill(
            child: SafeArea(
              left: false,
              right: false,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                    right: -MapZoomSlider.width / 2,
                    top: 0,
                    bottom: 0,
                    child: Align(
                      alignment: const Alignment(0, -0.1),
                      child: ValueListenableBuilder<double>(
                        valueListenable: _zoom,
                        builder: (context, zoom, _) => MapZoomSlider(
                          zoom: zoom,
                          minZoom: _minZoom,
                          maxZoom: _maxZoom,
                          onChanged: _onZoomChanged,
                          onStep: _onZoomStep,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Controls live inside SafeArea so they clear the status bar and any
          // notch/cutout insets; the map itself stays full-bleed underneath.
          Positioned.fill(
            child: SafeArea(
              child: Stack(
                children: [
                  if (markerState.status.isLoading && !isMapEmptyOverlayVisible)
                    const Positioned(
                      top: 84,
                      left: 0,
                      right: 0,
                      child: Center(child: AppProgressIndicator()),
                    ),
                  Positioned(
                    left: 16,
                    right: 16,
                    top: 76,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: AnimatedSwitcher(
                        duration: _emptyStateFadeDuration,
                        reverseDuration: _emptyStateFadeDuration,
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: isMapEmptyOverlayVisible
                            ? MapEmptyState(
                                key: const ValueKey('map-empty-state'),
                                refreshing: isMapEmptyOverlayRefreshing,
                              )
                            : const SizedBox.shrink(
                                key: ValueKey('map-empty-state-hidden'),
                              ),
                      ),
                    ),
                  ),
                  // Left vertical control stack (location, favourites, help),
                  // within thumb reach and clear of the disclaimer.
                  Positioned(
                    left: 16,
                    bottom: 76,
                    child:
                        ValueListenableBuilder<
                          ({double rotationRad, bool centered})
                        >(
                          valueListenable: _compass,
                          builder: (context, compass, _) => MapControlStack(
                            locationStatus: locationStatus,
                            isLocating: _isLocating,
                            rotationRad: compass.rotationRad,
                            centered: compass.centered,
                            favoritesCount: favoritesCount,
                            onLocation: _onLocationButtonTap,
                            onFavorites: _openFavorites,
                            onHelp: () {
                              Haptics.tap();
                              unawaited(showAppAboutDialog(context));
                            },
                          ),
                        ),
                  ),
                  // Top glass search bar — kept last so the field and its
                  // results dropdown sit above every map control on the Z axis.
                  Positioned(
                    left: 16,
                    right: 16,
                    top: 12,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        // Don't stretch the search field across wide screens.
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: MapSearchWidget(
                          hintText: l10n.map_search_hint,
                          originProvider: _searchOrigin,
                          onResultSelected: _onSearchResultSelected,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom strip — intentionally OUTSIDE SafeArea so it sits flush with
          // the very bottom edge and is covered (not pushed up) by the keyboard.
          // The minimal potability disclaimer sits just above the mandatory
          // Mapy.com attribution.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MapDisclaimer(
                  onTap: () {
                    Haptics.tap();
                    unawaited(showDisclaimerDialog(context));
                  },
                ),
                const SizedBox(height: 2),
                const MapAttribution(),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ],
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Status-bar glyphs read against the frosted scrim: dark glyphs over the
      // light wash (light theme), light glyphs over the dark wash (dark theme).
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: content,
    );
  }
}
