import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/backdrop_blur_scope.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_empty_state_controller.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/map_view_config.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/views/map_page_callbacks.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/views/map_page_view_controllers.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/views/map_page_view_state.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/map_canvas.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/map_overlay_controls.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/spring_marker_layer.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_status.dart';
import 'package:studanky_flutter_app/features/spring_detail/spring_detail_overlay.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Declarative map screen. State subscriptions and imperative orchestration
/// stay in the owning container; this view only renders state and forwards
/// events.
class MapPageView extends StatelessWidget {
  const MapPageView({
    required this.state,
    required this.controllers,
    required this.callbacks,
    super.key,
  });

  final MapPageViewState state;
  final MapPageViewControllers controllers;
  final MapPageCallbacks callbacks;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final camera = controllers.camera;
    final emptyVisible = state.emptyMode != MapEmptyOverlayMode.hidden;
    final detailOpen = state.detailDocumentId != null;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final searchBarHideDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : MapViewConfig.searchBarHideDuration;

    final MapSearchStatus? searchStatus;
    if (state.isOffline) {
      searchStatus = MapSearchStatus(
        id: 'offline',
        icon: Icons.wifi_off_rounded,
        title: l10n.offline_banner_title,
        message: l10n.offline_banner_message,
        accent: context.appColors.secondaryVariant1,
      );
    } else if (emptyVisible) {
      searchStatus = MapSearchStatus(
        id: 'empty',
        icon: Icons.search_off_rounded,
        title: l10n.map_empty_title,
        message: l10n.map_empty_message,
        accent: context.appColors.primaryMain,
        busy: state.emptyMode == MapEmptyOverlayMode.refreshing,
      );
    } else {
      searchStatus = null;
    }

    final markerLayer = SpringMarkerLayer(
      items: state.markers.items,
      config: state.platformConfig,
      selectedDocumentId: state.detailDocumentId,
      l10n: l10n,
      onClusterTap: (cluster) => camera.expandCluster(
        cluster,
        detailOpen: detailOpen,
        topInset: MediaQuery.viewPaddingOf(context).top,
      ),
      onSpringTap: callbacks.onSpringTap,
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
              locationActivated: state.location.activated,
              positionStream: controllers.location.positionStream,
              headingStream: controllers.location.headingStream,
              onMapReady: callbacks.onMapReady,
              onMapEvent: callbacks.onMapEvent,
              onMapTap: callbacks.onMapTap,
              onZoomStart: callbacks.onDismissKeyboard,
              onQuickZoomGestureActiveChanged: camera.setQuickZoomGestureActive,
            ),
          ),
          Positioned.fill(
            child: MapOverlayControls(
              zoom: camera.zoom,
              compass: camera.compass,
              locationStatus: state.location.status,
              isLocating: state.isLocating,
              showProgress:
                  state.markers.status.isLoading &&
                  !state.markers.visibleBoundsLoaded &&
                  !state.markers.hasVisibleMarkers &&
                  !emptyVisible &&
                  !state.isOffline,
              detailOpen: detailOpen,
              searchBarHideDuration: searchBarHideDuration,
              searchHint: l10n.map_search_hint,
              searchOrigin: callbacks.searchOrigin,
              searchStatus: searchStatus,
              onZoomChanged: camera.changeZoom,
              onZoomStep: camera.stepZoom,
              onLocation: callbacks.onLocation,
              onFavorites: callbacks.onFavorites,
              onHelp: callbacks.onHelp,
              onSearchResultSelected: callbacks.onSearchResultSelected,
              onDisclaimer: callbacks.onDisclaimer,
            ),
          ),
          SpringDetailOverlay(
            documentId: state.detailDocumentId,
            marker: state.detailMarker,
            onDismissed: callbacks.onCloseDetail,
            onExtentChanged: callbacks.onDetailSheetExtentChanged,
          ),
        ],
      ),
    );

    return PopScope(
      canPop: !detailOpen,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) callbacks.onCloseDetail();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDarkMode
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: BackdropGroup(
          child: ValueListenableBuilder<bool>(
            valueListenable: controllers.backdropBlur,
            child: content,
            builder: (context, blurEnabled, child) =>
                BackdropBlurScope(enabled: blurEnabled, child: child!),
          ),
        ),
      ),
    );
  }
}
