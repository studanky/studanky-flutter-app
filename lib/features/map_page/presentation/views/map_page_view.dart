import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/backdrop_blur_scope.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_camera_coordinator.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_empty_state_controller.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/map_view_config.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/map_canvas.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/map_overlay_controls.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/spring_marker_layer.dart';
import 'package:studanky_flutter_app/features/map_page/providers/map_marker_provider.dart';
import 'package:studanky_flutter_app/features/map_page/providers/user_location_provider.dart';
import 'package:studanky_flutter_app/features/map_page/utils/map_backdrop_blur_controller.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_status.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/platform_config.dart';
import 'package:studanky_flutter_app/features/spring_detail/spring_detail_overlay.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Declarative map screen. State subscriptions and imperative orchestration
/// stay in the owning container; this view only renders state and forwards
/// events.
class MapPageView extends StatelessWidget {
  const MapPageView({
    required this.camera,
    required this.backdropBlur,
    required this.markerState,
    required this.platformConfig,
    required this.locationState,
    required this.locationNotifier,
    required this.emptyState,
    required this.isOffline,
    required this.isLocating,
    required this.detailDocumentId,
    required this.detailMarker,
    required this.onMapReady,
    required this.onMapEvent,
    required this.onMapTap,
    required this.onDismissKeyboard,
    required this.onLocation,
    required this.onFavorites,
    required this.onHelp,
    required this.searchOrigin,
    required this.onSearchResultSelected,
    required this.onSpringTap,
    required this.onDisclaimer,
    required this.onCloseDetail,
    required this.onDetailSheetExtentChanged,
    super.key,
  });

  final MapCameraCoordinator camera;
  final MapBackdropBlurController backdropBlur;
  final MapMarkerState markerState;
  final PlatformConfig platformConfig;
  final UserLocationState locationState;
  final UserLocationNotifier locationNotifier;
  final MapEmptyStateController emptyState;
  final bool isOffline;
  final bool isLocating;
  final String? detailDocumentId;
  final SpringMarkerEntity? detailMarker;
  final VoidCallback onMapReady;
  final ValueChanged<MapEvent> onMapEvent;
  final VoidCallback onMapTap;
  final VoidCallback onDismissKeyboard;
  final VoidCallback onLocation;
  final VoidCallback onFavorites;
  final VoidCallback onHelp;
  final LatLng? Function() searchOrigin;
  final ValueChanged<MapSearchResult> onSearchResultSelected;
  final ValueChanged<SpringMarkerEntity> onSpringTap;
  final VoidCallback onDisclaimer;
  final VoidCallback onCloseDetail;
  final ValueChanged<double> onDetailSheetExtentChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final detailOpen = detailDocumentId != null;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final searchBarHideDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : MapViewConfig.searchBarHideDuration;

    final MapSearchStatus? searchStatus;
    if (isOffline) {
      searchStatus = MapSearchStatus(
        id: 'offline',
        icon: Icons.wifi_off_rounded,
        title: l10n.offline_banner_title,
        message: l10n.offline_banner_message,
        accent: Styles.appColors.secondaryVariant1,
      );
    } else if (emptyState.isVisible) {
      searchStatus = MapSearchStatus(
        id: 'empty',
        icon: Icons.search_off_rounded,
        title: l10n.map_empty_title,
        message: l10n.map_empty_message,
        accent: Styles.appColors.primaryMain,
        busy: emptyState.isRefreshing,
      );
    } else {
      searchStatus = null;
    }

    final markerLayer = SpringMarkerLayer(
      items: markerState.items,
      config: platformConfig,
      selectedDocumentId: detailDocumentId,
      l10n: l10n,
      onClusterTap: (cluster) => camera.expandCluster(
        cluster,
        detailOpen: detailOpen,
        topInset: MediaQuery.viewPaddingOf(context).top,
      ),
      onSpringTap: onSpringTap,
    );

    final content = SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: MapCanvas(
              controller: camera.mapController,
              quickZoomGestureActive: camera.quickZoomGestureActive,
              markerLayer: markerLayer,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              isDarkMode: isDarkMode,
              locationActivated: locationState.activated,
              positionStream: locationNotifier.positionStream,
              headingStream: locationNotifier.headingStream,
              onMapReady: onMapReady,
              onMapEvent: onMapEvent,
              onMapTap: onMapTap,
              onZoomStart: onDismissKeyboard,
              onQuickZoomGestureActiveChanged: camera.setQuickZoomGestureActive,
            ),
          ),
          Positioned.fill(
            child: MapOverlayControls(
              zoom: camera.zoom,
              compass: camera.compass,
              locationStatus: locationState.status,
              isLocating: isLocating,
              showProgress:
                  markerState.status.isLoading &&
                  !markerState.visibleBoundsLoaded &&
                  !markerState.hasVisibleMarkers &&
                  !emptyState.isVisible &&
                  !isOffline,
              detailOpen: detailOpen,
              searchBarHideDuration: searchBarHideDuration,
              searchHint: l10n.map_search_hint,
              searchOrigin: searchOrigin,
              searchStatus: searchStatus,
              onZoomChanged: camera.changeZoom,
              onZoomStep: camera.stepZoom,
              onLocation: onLocation,
              onFavorites: onFavorites,
              onHelp: onHelp,
              onSearchResultSelected: onSearchResultSelected,
              onDisclaimer: onDisclaimer,
            ),
          ),
          SpringDetailOverlay(
            documentId: detailDocumentId,
            marker: detailMarker,
            onDismissed: onCloseDetail,
            onExtentChanged: onDetailSheetExtentChanged,
          ),
        ],
      ),
    );

    return PopScope(
      canPop: !detailOpen,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) onCloseDetail();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDarkMode
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: BackdropGroup(
          child: ValueListenableBuilder<bool>(
            valueListenable: backdropBlur,
            child: content,
            builder: (context, blurEnabled, child) =>
                BackdropBlurScope(enabled: blurEnabled, child: child!),
          ),
        ),
      ),
    );
  }
}
