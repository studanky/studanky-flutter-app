import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/widgets/app_progress_indicator.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_camera_coordinator.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/user_location_state.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/map_view_config.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/map_attribution.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/map_control_stack.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/map_disclaimer.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/map_zoom_slider.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/status_bar_scrim.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/presentation/widgets/map_search_status.dart';
import 'package:studanky_flutter_app/features/map_search/presentation/widgets/map_search_widget.dart';

/// Floating controls and legal chrome above the full-bleed map surface.
class MapOverlayControls extends StatelessWidget {
  const MapOverlayControls({
    required this.zoom,
    required this.compass,
    required this.locationStatus,
    required this.isLocating,
    required this.showProgress,
    required this.detailOpen,
    required this.searchBarHideDuration,
    required this.searchHint,
    required this.searchOrigin,
    required this.searchStatus,
    required this.onZoomChanged,
    required this.onZoomStep,
    required this.onLocation,
    required this.onFavorites,
    required this.onHelp,
    required this.onSearchResultSelected,
    required this.onDisclaimer,
    super.key,
  });

  final ValueListenable<double> zoom;
  final ValueListenable<MapCompassState> compass;
  final LocationStatus locationStatus;
  final bool isLocating;
  final bool showProgress;
  final bool detailOpen;
  final Duration searchBarHideDuration;
  final String searchHint;
  final LatLng? Function() searchOrigin;
  final MapSearchStatus? searchStatus;
  final ValueChanged<double> onZoomChanged;
  final ValueChanged<double> onZoomStep;
  final VoidCallback onLocation;
  final VoidCallback onFavorites;
  final VoidCallback onHelp;
  final ValueChanged<MapSearchResult> onSearchResultSelected;
  final VoidCallback onDisclaimer;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(top: 0, left: 0, right: 0, child: StatusBarScrim()),
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
                      valueListenable: zoom,
                      builder: (context, value, _) => MapZoomSlider(
                        zoom: value,
                        minZoom: MapViewConfig.minZoom,
                        maxZoom: MapViewConfig.maxZoom,
                        onChanged: onZoomChanged,
                        onStep: onZoomStep,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: SafeArea(
            child: Stack(
              children: [
                if (showProgress)
                  const Positioned(
                    top: 84,
                    left: 0,
                    right: 0,
                    child: Center(child: AppProgressIndicator()),
                  ),
                Positioned(
                  left: 16,
                  bottom: 76,
                  child: ValueListenableBuilder<MapCompassState>(
                    valueListenable: compass,
                    builder: (context, value, _) => MapControlStack(
                      locationStatus: locationStatus,
                      isLocating: isLocating,
                      rotationRad: value.rotationRad,
                      centered: value.centered,
                      onLocation: onLocation,
                      onFavorites: onFavorites,
                      onHelp: onHelp,
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  top: 16,
                  child: IgnorePointer(
                    ignoring: detailOpen,
                    child: ExcludeSemantics(
                      excluding: detailOpen,
                      child: AnimatedSlide(
                        offset: detailOpen
                            ? const Offset(0, -0.4)
                            : Offset.zero,
                        duration: searchBarHideDuration,
                        curve: Curves.easeOutCubic,
                        child: AnimatedOpacity(
                          opacity: detailOpen ? 0 : 1,
                          duration: searchBarHideDuration,
                          curve: Curves.easeOutCubic,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: MapSearchWidget(
                                hintText: searchHint,
                                originProvider: searchOrigin,
                                onResultSelected: onSearchResultSelected,
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
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            maintainBottomViewPadding: true,
            minimum: const EdgeInsets.only(
              bottom: MapViewConfig.bottomLegalStripMinimumGap,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MapDisclaimer(onTap: onDisclaimer),
                const SizedBox(height: 8),
                const MapAttribution(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
