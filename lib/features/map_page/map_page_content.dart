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
import 'package:studanky_flutter_app/core/navigation/app_router.dart';
import 'package:studanky_flutter_app/core/providers/connectivity_status_provider.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/app_progress_indicator.dart';
import 'package:studanky_flutter_app/core/widgets/glass_snack_bar.dart';
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
import 'package:studanky_flutter_app/features/map_page/widgets/map_zoom_slider.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/marker.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/status_bar_scrim.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result_type.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_status.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_widget.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/spring_detail_overlay.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/spring_detail_sheet.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

class MapPageContent extends ConsumerStatefulWidget {
  const MapPageContent({super.key, this.detailDocumentId, this.detailMarker});

  /// Spring whose detail sheet is open (route `/map/spring/:documentId`), or
  /// null on plain `/map`. The sheet lives inside this page's stack — the two
  /// routes resolve to one live map page — so the map stays interactive under
  /// the half-open detail and tapping another marker switches in one tap.
  final String? detailDocumentId;

  /// Already-loaded marker for an instant sheet header; null on a public link.
  final SpringMarkerEntity? detailMarker;

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
  /// programmatic [MapEventSource.mapController] animations). Used to dismiss
  /// the keyboard once the user takes over the camera.
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

  /// Fade/slide of the search bar as the detail sheet takes over — slightly
  /// quicker than the sheet's 300ms entrance so the bar is out of the way by
  /// the time the sheet settles.
  static const Duration _searchBarHideDuration = Duration(milliseconds: 220);

  /// Minimum breathing room below the legal strip on devices without a bottom
  /// safe-area inset.
  static const double _bottomLegalStripMinimumGap = 8;

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

  /// Last reported detail-sheet extent. Kept outside Flutter state because it
  /// only affects future camera calculations; rebuilding the map on every drag
  /// frame would be wasteful.
  double _detailSheetExtent = SpringDetailSheet.initialSize;

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

  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(onResume: _onAppResumed);
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _cameraDebounceTimer?.cancel();
    _emptyStateRevealTimer?.cancel();
    _animator.dispose();
    _compass.dispose();
    _zoom.dispose();
    super.dispose();
  }

  /// On resume, refresh the markers if their cache has gone stale — the tile
  /// time-to-live decides, so flicking in and out of the app costs nothing.
  ///
  /// An offline map is the one case that must force a request past the cache.
  /// `ConnectivityController` re-checks the interface on resume and can flip
  /// itself *to* offline, but deliberately never back to online — a live
  /// interface doesn't prove the backend is reachable. Recovery is therefore
  /// left to the next real request, and on a cached map there would not be one.
  void _onAppResumed() {
    if (!_isMapReady) return;

    if (ref.read(connectivityStatusProvider).isOffline) {
      unawaited(_markerNotifier.refreshVisible());
      return;
    }
    _emitCamera();
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
      _dismissKeyboard();
    }
    _cameraDebounceTimer?.cancel();
    _cameraDebounceTimer = Timer(_cameraDebounce, _emitCamera);
  }

  void _onMapTap() {
    _dismissKeyboard();
    if (widget.detailDocumentId != null) _closeSpringDetail();
  }

  /// Map-app convention (Google/Apple/Mapy.cz): any touch on the map ends text
  /// entry — the keyboard and the suggestions get out of the way — but the
  /// typed query itself stays in the field as context; only the field's ✕
  /// clears it. Programmatic camera moves ([MapEventSource.mapController]) are
  /// excluded so animating to a search result doesn't close anything.
  void _dismissKeyboard() {
    final focus = FocusManager.instance.primaryFocus;
    // Only a real focused widget (the search field) — unfocusing the idle
    // page-level scope node would be pointless churn on every map gesture.
    if (focus is FocusScopeNode) return;
    focus?.unfocus();
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
    // Tick on a fine grid (every half zoom level) so dragging the slider feels
    // like a picker wheel ticking under the thumb — not clunking in whole-level
    // jumps that lag behind how far the finger has actually moved.
    const detentStep = 0.5;
    final detent = (clamped / detentStep).round();
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
    // [expansionZoom] is only the level at which the cluster *starts* to break
    // apart — landing exactly there leaves the points still cramped. Push a few
    // levels closer (clamped to the max) so the children spread out with room
    // to read them. With detail open, target the currently visible map strip,
    // not the centre of the obscured full viewport.
    final targetZoom = (cluster.expansionZoom + _clusterExpandZoomBoost)
        .clamp(_minZoom, _maxZoom)
        .toDouble();
    final targetCenter = widget.detailDocumentId == null
        ? cluster.position
        : _detailFocusCenter(
            cluster.position,
            zoom: targetZoom,
            sheetExtent: _detailSheetExtent,
          );
    unawaited(_animator.animateTo(center: targetCenter, zoom: targetZoom));
  }

  /// Camera centre that parks [target] in the middle of the map strip left
  /// visible above the half-open detail sheet — so opening the detail shows
  /// the selected point *and its surroundings* instead of burying it under the
  /// sheet.
  ///
  /// The strip is measured in *safe-area* terms: the detail page insets the
  /// sheet below the status bar, so the sheet's pixel height is
  /// `extent · (viewport − topInset)`, and the target belongs at the midpoint
  /// between the safe-area top and the sheet's top edge:
  ///
  ///   sheetTop = h − (h − topInset)·s
  ///   targetY  = (topInset + sheetTop) / 2
  ///   shift    = h/2 − targetY = ((h − topInset)·s − topInset) / 2
  ///
  /// [MapCamera.screenOffsetToLatLng] works in screen space, so map rotation
  /// is accounted for.
  LatLng _detailFocusCenter(
    LatLng target, {
    double? zoom,
    double sheetExtent = SpringDetailSheet.initialSize,
  }) {
    final onTarget = _mapController.camera.withPosition(
      center: target,
      zoom: zoom,
    );
    final size = onTarget.nonRotatedSize;
    final topInset = MediaQuery.viewPaddingOf(context).top;
    final extent = sheetExtent.clamp(0.0, 1.0).toDouble();
    final shift = ((size.height - topInset) * extent - topInset) / 2;
    return onTarget.screenOffsetToLatLng(
      size.center(Offset.zero) + Offset(0, shift),
    );
  }

  void _onDetailSheetExtentChanged(double extent) {
    _detailSheetExtent = extent.clamp(0.0, 1.0).toDouble();
  }

  /// Opens (or switches) the detail sheet for [spring] by navigating to its
  /// route — the sheet is part of this page, so this is a parameter change on
  /// the live map, and the marker highlight (selection green) follows the
  /// route param. Works both from a closed map and with another spring's
  /// detail already open (the one-tap switch).
  void _openSpringDetail(SpringMarkerEntity spring) {
    SpringRoute(documentId: spring.documentId, $extra: spring).go(context);
  }

  /// Closes an open detail sheet: back to plain `/map` (flips the param,
  /// which plays the sheet's exit slide).
  void _closeSpringDetail() => const MapRoute().go(context);

  void _onSpringTap(SpringMarkerEntity spring) {
    _logger.fine('Spring tapped: ${spring.documentId} (${spring.name})');
    FocusScope.of(context).unfocus();
    // Glide the marker into the visible upper strip while the sheet slides in.
    unawaited(_animator.animateTo(center: _detailFocusCenter(spring.position)));
    _openSpringDetail(spring);
  }

  /// Opens the favourites popup; if the user picks one, animate-centers the map
  /// on it and opens its detail.
  Future<void> _openFavorites() async {
    FocusScope.of(context).unfocus();
    final selected = await showFavoritesDialog(context);
    if (selected == null || !mounted) return;

    unawaited(
      _animator.animateTo(
        center: _detailFocusCenter(selected.position, zoom: _recenterMinZoom),
        zoom: _recenterMinZoom,
      ),
    );
    _openSpringDetail(selected);
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
        center: _detailFocusCenter(spring.position, zoom: _springSearchZoom),
        zoom: _springSearchZoom,
      );
      if (!mounted || selectionToken != _searchSelectionToken) return;
      _openSpringDetail(spring);
      return;
    }

    final bounds = result.bounds;
    if (bounds != null && !bounds.isPoint) {
      // Fit the whole locality in view, leaving room for the overlay controls
      // (search bar on top, buttons + attribution at the bottom), then animate
      // to the resulting camera.
      final bottomSafeArea = MediaQuery.viewPaddingOf(context).bottom;
      final bottomOverlayLift = math.max(
        0.0,
        bottomSafeArea - _bottomLegalStripMinimumGap,
      );
      final fitted = CameraFit.bounds(
        bounds: LatLngBounds(bounds.southWest, bounds.northEast),
        padding: EdgeInsets.fromLTRB(48, 110, 48, 96 + bottomOverlayLift),
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
    ref
      ..listen<MapMarkerState>(mapMarkerProvider, (_, next) {
        _syncMapEmptyState(next);
      })
      // Reconnected after being offline → put a real request on the wire for
      // the current camera, so an idle map recovers on its own without the
      // user panning.
      //
      // Forced past the tile cache on purpose. `ConnectivityController` turns
      // optimistically online off a bare interface-up signal and leaves the
      // proof to "the next failing request" — but a map whose tiles are still
      // fresh has no next request for minutes, so behind a captive portal the
      // banner would clear without anything ever reaching the backend.
      ..listen<ConnectivityStatus>(connectivityStatusProvider, (
        previous,
        next,
      ) {
        if (previous == ConnectivityStatus.offline &&
            next == ConnectivityStatus.online &&
            _isMapReady) {
          unawaited(_markerNotifier.refreshVisible());
        }
      });

    final markerState = ref.watch(mapMarkerProvider);
    final config = ref.watch(platformConfigControllerProvider);
    final locationStatus = ref.watch(userLocationProvider).status;
    // Advisory only, optimistic by default: the offline banner takes the shared
    // top-center status slot ahead of the empty state once the network layer
    // confirms the backend is unreachable.
    final isOffline = ref.watch(
      connectivityStatusProvider.select((status) => status.isOffline),
    );
    final l10n = context.l10n;
    final isDetailOpen = widget.detailDocumentId != null;
    // Honour the OS reduce-motion setting: the bar still disappears, just
    // without the transition.
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final searchBarHideDuration = reduceMotion
        ? Duration.zero
        : _searchBarHideDuration;
    final isMapEmptyOverlayVisible = _isMapEmptyOverlayVisible;
    final isMapEmptyOverlayRefreshing =
        _mapEmptyOverlayMode == _MapEmptyOverlayMode.refreshing;

    // Advisory status attached *under the search field* (replacing the old
    // free-floating banner that twinned the search bar). Offline takes
    // precedence over the generic "no springs here" empty state; a warm accent
    // flags offline as attention, the calm brand blue marks an empty viewport.
    final statusColors = Styles.appColors;
    final MapSearchStatus? searchStatus;
    if (isOffline) {
      searchStatus = MapSearchStatus(
        id: 'offline',
        icon: Icons.wifi_off_rounded,
        title: l10n.offline_banner_title,
        message: l10n.offline_banner_message,
        accent: statusColors.secondaryVariant1,
      );
    } else if (isMapEmptyOverlayVisible) {
      searchStatus = MapSearchStatus(
        id: 'empty',
        icon: Icons.search_off_rounded,
        title: l10n.map_empty_title,
        message: l10n.map_empty_message,
        accent: statusColors.primaryMain,
        busy: isMapEmptyOverlayRefreshing,
      );
    } else {
      searchStatus = null;
    }

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
            selected: spring.documentId == widget.detailDocumentId,
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final mapBackgroundColor = theme.scaffoldBackgroundColor;

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
                // Avoid flutter_map's light grey default while tiles load.
                backgroundColor: mapBackgroundColor,
                onMapReady: _onMapReady,
                onMapEvent: _onMapEvent,
                // A bare tap on the map (no marker hit) dismisses the keyboard,
                // like panning does — and, map-app convention, closes an open
                // detail sheet. Marker taps never reach here.
                onTap: (_, _) => _onMapTap(),
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
                  // Spin only while the visible area has nothing to show. A
                  // fetch over already-drawn markers is background revalidation
                  // (a stale tile, a resume probe) — a spinner there would blink
                  // over data the user can already see.
                  if (markerState.status.isLoading &&
                      !markerState.visibleBoundsLoaded &&
                      !isMapEmptyOverlayVisible &&
                      !isOffline)
                    const Positioned(
                      top: 84,
                      left: 0,
                      right: 0,
                      child: Center(child: AppProgressIndicator()),
                    ),
                  // The offline / empty-map status now lives *inside* the search
                  // bar (see `searchStatus` → MapSearchWidget), so it no longer
                  // occupies this top-center slot as a separate banner.
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
                            onLocation: _onLocationButtonTap,
                            onFavorites: _openFavorites,
                            onHelp: () =>
                                unawaited(showAppAboutDialog(context)),
                          ),
                        ),
                  ),
                  // Top glass search bar — kept last so the field and its
                  // results dropdown sit above every map control on the Z axis.
                  //
                  // While a spring detail is open the bar fades (and nudges) out
                  // of the way — map-app convention: the place sheet owns the
                  // screen, and a live search bar would fight it (its dropdown
                  // and keyboard would land on top of the sheet). It stays
                  // mounted so the typed query survives the round trip, but is
                  // inert to touch and invisible to screen readers meanwhile.
                  Positioned(
                    left: 16,
                    right: 16,
                    top: 16,
                    child: IgnorePointer(
                      ignoring: isDetailOpen,
                      child: ExcludeSemantics(
                        excluding: isDetailOpen,
                        child: AnimatedSlide(
                          offset: isDetailOpen
                              ? const Offset(0, -0.4)
                              : Offset.zero,
                          duration: searchBarHideDuration,
                          curve: Curves.easeOutCubic,
                          child: AnimatedOpacity(
                            opacity: isDetailOpen ? 0 : 1,
                            duration: searchBarHideDuration,
                            curve: Curves.easeOutCubic,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: ConstrainedBox(
                                // Don't stretch the search field across wide
                                // screens.
                                constraints: const BoxConstraints(
                                  maxWidth: 600,
                                ),
                                child: MapSearchWidget(
                                  hintText: l10n.map_search_hint,
                                  originProvider: _searchOrigin,
                                  onResultSelected: _onSearchResultSelected,
                                  status: searchStatus,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom legal strip lives inside SafeArea while the map remains
          // full-bleed underneath. maintainBottomViewPadding keeps the strip
          // anchored to the device safe inset when the keyboard appears; the
          // keyboard still overlays it because the Scaffold does not resize.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              maintainBottomViewPadding: true,
              minimum: const EdgeInsets.only(
                bottom: _bottomLegalStripMinimumGap,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MapDisclaimer(
                    onTap: () => unawaited(showDisclaimerDialog(context)),
                  ),
                  const MapAttribution(),
                ],
              ),
            ),
          ),
          // Spring detail — a widget in this stack, not a route, so the map
          // stays interactive behind the half-open sheet and tapping another
          // marker switches the detail in one tap. Last child: above every
          // control on the Z axis.
          SpringDetailOverlay(
            documentId: widget.detailDocumentId,
            marker: widget.detailMarker,
            onDismissed: _closeSpringDetail,
            onExtentChanged: _onDetailSheetExtentChanged,
          ),
        ],
      ),
    );

    return PopScope(
      // While a detail sheet is open, the system back gesture/button closes it
      // instead of leaving the map (the page never pops — the route param
      // flips and the sheet slides away).
      canPop: widget.detailDocumentId == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _closeSpringDetail();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        // Status-bar glyphs read against the frosted scrim: dark glyphs over
        // the light wash (light theme), light glyphs over the dark wash (dark
        // theme).
        value: isDarkMode
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: content,
      ),
    );
  }
}
