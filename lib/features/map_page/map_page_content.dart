import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/core/navigation/app_router.dart';
import 'package:studanky_flutter_app/core/providers/connectivity_status_provider.dart';
import 'package:studanky_flutter_app/core/widgets/glass_snack_bar.dart';
import 'package:studanky_flutter_app/features/favorites/widgets/favorites_dialog.dart';
import 'package:studanky_flutter_app/features/legal/providers/legal_onboarding_provider.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/deep_link_spring_focus_controller.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_camera_coordinator.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_empty_state_controller.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_search_selection_controller.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/map_view_config.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/views/map_page_view.dart';
import 'package:studanky_flutter_app/features/map_page/providers/map_marker_provider.dart';
import 'package:studanky_flutter_app/features/map_page/providers/user_location_provider.dart';
import 'package:studanky_flutter_app/features/map_page/utils/map_backdrop_blur_controller.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/about_dialog.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/disclaimer_dialog.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/spring_detail_sheet.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
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

class _MapPageContentState extends ConsumerState<MapPageContent>
    with SingleTickerProviderStateMixin {
  final Logger _logger = Logger('MapPageContent');
  Timer? _cameraDebounceTimer;
  final MapEmptyStateController _emptyState = MapEmptyStateController();
  late final DeepLinkSpringFocusController _deepLinkFocus;
  late final MapCameraCoordinator _camera = MapCameraCoordinator(
    vsync: this,
    initialDetailSheetExtent: SpringDetailSheet.initialSize,
  );
  late final MapSearchSelectionController _searchSelection =
      MapSearchSelectionController(_camera, SpringDetailSheet.initialSize);

  /// True while a tap on the "my location" button is waiting for the first fix.
  bool _isLocating = false;
  bool _isMapReady = false;
  String? _activeLanguageTag;

  /// Only backdrop-filter widgets listen to this controller, so toggling their
  /// expensive operation never rebuilds FlutterMap or its tile/marker layers.
  final MapBackdropBlurController _backdropBlur = MapBackdropBlurController();

  MapMarkerNotifier get _markerNotifier => ref.read(mapMarkerProvider.notifier);

  String get _languageTag =>
      _activeLanguageTag ?? Localizations.localeOf(context).toLanguageTag();

  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _deepLinkFocus = DeepLinkSpringFocusController(
      ref,
      () => mounted,
      (position) => _camera.animateTo(
        center: _detailFocusCenter(
          position,
          zoom: MapViewConfig.springSearchZoom,
        ),
        zoom: MapViewConfig.springSearchZoom,
      ),
    );
    _emptyState.addListener(_onEmptyStateChanged);
    _lifecycleListener = AppLifecycleListener(onResume: _onAppResumed);
  }

  void _onEmptyStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageTag = Localizations.localeOf(context).toLanguageTag();
    final previousLanguageTag = _activeLanguageTag;
    if (previousLanguageTag == languageTag) return;
    final shouldReloadCamera = previousLanguageTag != null && _isMapReady;
    _activeLanguageTag = languageTag;
    _updateDeepLinkedSpringFocus();

    if (shouldReloadCamera) _cameraDebounceTimer?.cancel();
    // Riverpod state must not be changed while didChangeDependencies is part
    // of the widget's build. Synchronize the tag after this frame instead.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _activeLanguageTag != languageTag) return;
      _markerNotifier.onLanguageTagChanged(languageTag);
      if (shouldReloadCamera) _emitCamera();
    });
  }

  @override
  void didUpdateWidget(MapPageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateDeepLinkedSpringFocus();
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _deepLinkFocus.dispose();
    _cameraDebounceTimer?.cancel();
    _emptyState.dispose();
    _camera.dispose();
    _backdropBlur.dispose();
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
      unawaited(_markerNotifier.refreshVisible(languageTag: _languageTag));
      return;
    }
    _emitCamera();
  }

  void _onMapReady() {
    _isMapReady = true;
    // First load is immediate; subsequent camera changes are debounced.
    _emitCamera();
    _updateCameraFeedback();
    _deepLinkFocus.markMapReady();
    if (ref.read(userLocationProvider).activated) {
      if (widget.detailDocumentId == null) {
        unawaited(_centerOnUserLocation());
      }
    } else {
      unawaited(_activateLocationIfPermissionAlreadyGranted());
    }
  }

  String? get _deepLinkedSpringId =>
      widget.detailMarker == null ? widget.detailDocumentId : null;

  void _updateDeepLinkedSpringFocus() {
    _deepLinkFocus.update(
      documentId: _deepLinkedSpringId,
      languageTag: _activeLanguageTag,
    );
  }

  Future<void> _activateLocationIfPermissionAlreadyGranted() async {
    if (!ref.read(legalOnboardingProvider)) return;

    await ref.read(userLocationProvider.notifier).activateIfPermissionGranted();
  }

  void _onMapEvent(MapEvent event) {
    // Orientation/centered feedback must be live (every frame of a rotate or
    // pan), so update it immediately; only the marker fetch is debounced.
    _updateCameraFeedback();
    _updateBackdropBlur(event);
    _emptyState.markRefreshing();
    if (MapViewConfig.userMoveSources.contains(event.source)) {
      _dismissKeyboard();
    }
    _cameraDebounceTimer?.cancel();
    _cameraDebounceTimer = Timer(MapViewConfig.cameraDebounce, _emitCamera);
  }

  void _updateBackdropBlur(MapEvent event) {
    // Start/end/tap events do not repaint map pixels. Actual camera updates all
    // implement MapEventWithMove, including drag, pinch, fling, wheel, quick
    // zoom, the edge slider, and MapCameraAnimator controller ticks.
    if (event is! MapEventWithMove) return;

    _backdropBlur.onCameraMoved();
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

  void _updateCameraFeedback() {
    if (!mounted) return;
    final user = ref.read(userLocationProvider.notifier).lastKnownPosition;
    _camera.updateFeedback(user);
  }

  void _emitCamera() {
    if (!mounted) return;
    final camera = _camera.mapController.camera;
    unawaited(
      _markerNotifier
          .onCameraChanged(
            camera.visibleBounds,
            camera.zoom,
            languageTag: _languageTag,
          )
          .whenComplete(() {
            if (!mounted) return;
            _emptyState.sync(ref.read(mapMarkerProvider));
          }),
    );
  }

  /// Requests permission and centers the map on the user's first fix. On
  /// failure it leaves the map at the default center and shows a subtle notice.
  Future<void> _centerOnUserLocation() async {
    if (!ref.read(legalOnboardingProvider)) {
      _logger.warning(
        'Ignoring location request before legal onboarding acknowledgement',
      );
      return;
    }

    final location = await ref.read(userLocationProvider.notifier).firstFix();

    // This is startup-only automatic centering. A spring route may have opened
    // while the GPS fix was pending; its explicit target takes priority. The
    // location button uses `_recenterOnUser` and remains an intentional
    // user-controlled override.
    if (!mounted || widget.detailDocumentId != null) return;

    if (location != null) {
      _camera.moveDirect(location, MapViewConfig.defaultZoom);
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
    if (_camera.resetNorthIfNeeded()) return;
    unawaited(_recenterOnUser());
  }

  /// Recenters the map on the user. Uses the last known fix for an instant
  /// response, otherwise acquires one (driving the permission flow on first
  /// use) and falls back to a status message if the location is unavailable.
  Future<void> _recenterOnUser() async {
    if (_isLocating) return;
    if (!ref.read(legalOnboardingProvider)) {
      _logger.warning(
        'Ignoring location button before legal onboarding acknowledgement',
      );
      return;
    }

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
    _camera.moveToUser(location);
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
  ///   targetY  = (topInset + sheetTop) / 2 + downwardOffset
  ///   shift    = h/2 − targetY
  ///            = ((h − topInset)·s − topInset) / 2 − downwardOffset
  ///
  /// [MapCamera.screenOffsetToLatLng] works in screen space, so map rotation
  /// is accounted for.
  LatLng _detailFocusCenter(
    LatLng target, {
    double? zoom,
    double sheetExtent = SpringDetailSheet.initialSize,
  }) => _camera.detailFocusCenter(
    target,
    topInset: MediaQuery.viewPaddingOf(context).top,
    zoom: zoom,
    sheetExtent: sheetExtent,
  );

  void _onDetailSheetExtentChanged(double extent) {
    _camera.updateDetailSheetExtent(extent);
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
    unawaited(_camera.animateTo(center: _detailFocusCenter(spring.position)));
    _openSpringDetail(spring);
  }

  /// Opens the favourites popup; if the user picks one, animate-centers the map
  /// on it and opens its detail.
  Future<void> _openFavorites() async {
    FocusScope.of(context).unfocus();
    final selected = await showFavoritesDialog(context);
    if (selected == null || !mounted) return;

    unawaited(
      _camera.animateTo(
        center: _detailFocusCenter(
          selected.position,
          zoom: MapViewConfig.recenterMinZoom,
        ),
        zoom: MapViewConfig.recenterMinZoom,
      ),
    );
    _openSpringDetail(selected);
  }

  void _onSearchResultSelected(MapSearchResult result) {
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    final viewPadding = MediaQuery.viewPaddingOf(context);
    unawaited(
      _searchSelection.select(
        result,
        topInset: viewPadding.top,
        bottomInset: viewPadding.bottom,
        onSpringSelected: (spring) {
          if (mounted) _openSpringDetail(spring);
        },
      ),
    );
  }

  LatLng? _searchOrigin() {
    if (!_isMapReady) return null;
    return _searchSelection.origin;
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen<MapMarkerState>(mapMarkerProvider, (_, next) {
        _emptyState.sync(next);
      })
      ..listen<UserLocationState>(userLocationProvider, (previous, next) {
        if (!_isMapReady || !next.activated) return;
        if (previous?.activated == true) return;
        // An opened spring is the explicit camera target. Location activation
        // may still enable the blue dot, but must not steal the camera.
        if (widget.detailDocumentId != null) return;
        // A tap on "my location" already owns the first-fix camera move via
        // _recenterOnUser(); don't also run the onboarding-startup recenter.
        if (_isLocating) return;
        unawaited(_centerOnUserLocation());
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
          unawaited(_markerNotifier.refreshVisible(languageTag: _languageTag));
        }
      });

    return MapPageView(
      camera: _camera,
      backdropBlur: _backdropBlur,
      markerState: ref.watch(mapMarkerProvider),
      platformConfig: ref.watch(platformConfigControllerProvider),
      locationState: ref.watch(userLocationProvider),
      locationNotifier: ref.read(userLocationProvider.notifier),
      emptyState: _emptyState,
      isOffline: ref.watch(
        connectivityStatusProvider.select((status) => status.isOffline),
      ),
      isLocating: _isLocating,
      detailDocumentId: widget.detailDocumentId,
      detailMarker: widget.detailMarker,
      onMapReady: _onMapReady,
      onMapEvent: _onMapEvent,
      onMapTap: _onMapTap,
      onDismissKeyboard: _dismissKeyboard,
      onLocation: _onLocationButtonTap,
      onFavorites: _openFavorites,
      onHelp: () => unawaited(showAppAboutDialog(context)),
      searchOrigin: _searchOrigin,
      onSearchResultSelected: _onSearchResultSelected,
      onSpringTap: _onSpringTap,
      onDisclaimer: () => unawaited(showDisclaimerDialog(context)),
      onCloseDetail: _closeSpringDetail,
      onDetailSheetExtentChanged: _onDetailSheetExtentChanged,
    );
  }
}
