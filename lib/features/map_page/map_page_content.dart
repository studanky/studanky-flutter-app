import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/app_progress_indicator.dart';
import 'package:studanky_flutter_app/features/favorites/providers/favorites_provider.dart';
import 'package:studanky_flutter_app/features/favorites/widgets/favorites_sheet.dart';
import 'package:studanky_flutter_app/features/map_page/constants/map_page_constants.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_cluster_item.dart';
import 'package:studanky_flutter_app/features/map_page/providers/map_marker_provider.dart';
import 'package:studanky_flutter_app/features/map_page/providers/user_location_provider.dart';
import 'package:studanky_flutter_app/features/map_page/utils/map_camera_animator.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/cluster_marker.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/marker.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_widget.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/spring_detail_sheet.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

class MapPageContent extends ConsumerStatefulWidget {
  const MapPageContent({super.key});

  @override
  ConsumerState<MapPageContent> createState() => _MapPageContentState();
}

class _MapPageContentState extends ConsumerState<MapPageContent>
    with SingleTickerProviderStateMixin {
  // Default center (roughly the center of the Czech Republic) – used until /
  // unless the user's location is available.
  static const LatLng _initialCenter = LatLng(49.5630, 15.9398);
  static const double _defaultZoom = 14.5;

  /// When recentering on the user, never stay zoomed further out than this so
  /// the location dot is comfortably in view.
  static const double _recenterMinZoom = 15.0;

  /// Map center within this many metres of the user's fix counts as "centered".
  static const double _centeredThresholdMeters = 25;

  /// Map rotation (degrees) below which north is treated as "up".
  static const double _northEpsilonDegrees = 1.0;

  /// Coalesce rapid pan/zoom events into one fetch once the map goes idle
  /// (api-reference.md §3.1). Reclustering itself runs inside the notifier.
  static const Duration _cameraDebounce = Duration(milliseconds: 300);

  final MapController _mapController = MapController();
  final Logger _logger = Logger('MapPageContent');
  Timer? _cameraDebounceTimer;

  /// True while a tap on the "my location" button is waiting for the first fix.
  bool _isLocating = false;

  /// Live map orientation + centered state for the compass/location button.
  /// Kept in a [ValueNotifier] so map rotation repaints only the button, never
  /// the whole map.
  final ValueNotifier<({double rotationRad, bool centered})> _compass =
      ValueNotifier((rotationRad: 0, centered: false));

  late final MapCameraAnimator _animator = MapCameraAnimator(
    mapController: _mapController,
    vsync: this,
  );

  MapMarkerNotifier get _markerNotifier => ref.read(mapMarkerProvider.notifier);

  @override
  void dispose() {
    _cameraDebounceTimer?.cancel();
    _animator.dispose();
    _compass.dispose();
    super.dispose();
  }

  void _onMapReady() {
    // First load is immediate; subsequent camera changes are debounced.
    _emitCamera();
    _updateCompass();
    unawaited(_centerOnUserLocation());
  }

  void _onMapEvent(MapEvent event) {
    // Orientation/centered feedback must be live (every frame of a rotate or
    // pan), so update it immediately; only the marker fetch is debounced.
    _updateCompass();
    _cameraDebounceTimer?.cancel();
    _cameraDebounceTimer = Timer(_cameraDebounce, _emitCamera);
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
  }

  void _emitCamera() {
    if (!mounted) return;
    final camera = _mapController.camera;
    unawaited(
      _markerNotifier.onCameraChanged(camera.visibleBounds, camera.zoom),
    );
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
    // Animate to the level at which the cluster breaks apart, centred on it.
    // The resulting map events re-trigger clustering for the new viewport.
    unawaited(
      _animator.animateTo(
        center: cluster.position,
        zoom: cluster.expansionZoom,
      ),
    );
  }

  void _onSpringTap(SpringMarkerEntity spring) {
    _logger.fine('Spring tapped: ${spring.documentId} (${spring.name})');
    FocusScope.of(context).unfocus();
    unawaited(showSpringDetailSheet(context, marker: spring));
  }

  /// Opens the favourites popup; if the user picks one, animate-centers the map
  /// on it and opens its detail.
  Future<void> _openFavorites() async {
    FocusScope.of(context).unfocus();
    final selected = await showFavoritesSheet(context);
    if (selected == null || !mounted) return;

    unawaited(
      _animator.animateTo(center: selected.position, zoom: _recenterMinZoom),
    );
    unawaited(showSpringDetailSheet(context, marker: selected));
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
    final config = ref.watch(platformConfigControllerProvider);
    final locationStatus = ref.watch(userLocationProvider).status;
    final favoritesCount = ref.watch(
      favoritesControllerProvider.select((favorites) => favorites.length),
    );

    final markers = <Marker>[
      for (final item in markerState.items)
        switch (item) {
          Cluster() => buildClusterMarker(
            item,
            onTap: () => _onClusterTap(item),
          ),
          SpringPoint(:final spring) => buildSpringMarker(
            spring,
            config.iconFor(spring.status.wireValue, spring.statusUpdatedAt),
            onTap: () => _onSpringTap(spring),
          ),
        },
    ];

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
                onMapEvent: _onMapEvent,
                interactionOptions: const InteractionOptions(
                  flags:
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.pinchMove |
                      InteractiveFlag.doubleTapZoom |
                      InteractiveFlag.drag |
                      InteractiveFlag.rotate,
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
          if (markerState.status.isLoading)
            Positioned(
              top: MediaQuery.of(context).padding.top + 72,
              left: 0,
              right: 0,
              child: const Center(child: AppProgressIndicator()),
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
          Positioned(
            left: 16,
            bottom: 16,
            child: ValueListenableBuilder<({double rotationRad, bool centered})>(
              valueListenable: _compass,
              builder: (context, compass, _) => _MyLocationButton(
                status: locationStatus,
                isLocating: _isLocating,
                rotationRad: compass.rotationRad,
                centered: compass.centered,
                onPressed: _onLocationButtonTap,
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: _FavoritesButton(
              count: favoritesCount,
              onPressed: _openFavorites,
            ),
          ),
        ],
      ),
    );
  }
}

/// Combined compass + "my location" control (mapy.com style): a white circular
/// button showing a cross whose red arm always points to true north (rotating
/// with the map) and a centre dot that is filled when the map is centered on
/// the user and hollow otherwise. A spinner replaces it while the first fix is
/// being acquired.
class _MyLocationButton extends StatelessWidget {
  const _MyLocationButton({
    required this.status,
    required this.isLocating,
    required this.rotationRad,
    required this.centered,
    required this.onPressed,
  });

  final LocationStatus status;
  final bool isLocating;

  /// Current map rotation in radians; the north arm rotates by this to match
  /// the map content so it keeps pointing at true north.
  final double rotationRad;

  /// Whether the map is currently centered on the user's position.
  final bool centered;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final unavailable =
        status == LocationStatus.denied ||
        status == LocationStatus.deniedForever ||
        status == LocationStatus.serviceOff;

    final dotColor = unavailable
        ? colors.neutral500
        : (centered ? colors.primaryMain : colors.neutral700);

    return Semantics(
      button: true,
      label: context.l10n.map_my_location,
      child: Material(
        color: colors.onNeutral,
        elevation: 3,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLocating ? null : onPressed,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: isLocating
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colors.primaryMain,
                      ),
                    )
                  : CustomPaint(
                      size: const Size.square(26),
                      painter: _CompassPainter(
                        // Match the map's own layer rotation so the red arm
                        // tracks true north (flutter_map rotates content by
                        // +rotationRad).
                        rotationRad: rotationRad,
                        centered: centered,
                        northColor: colors.error,
                        armColor: colors.neutral500,
                        dotColor: dotColor,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular control that opens the saved-springs popup, badged with the count.
class _FavoritesButton extends StatelessWidget {
  const _FavoritesButton({required this.count, required this.onPressed});

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;

    return Semantics(
      button: true,
      label: context.l10n.map_favorites,
      child: Material(
        color: colors.onNeutral,
        elevation: 3,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: Badge(
                isLabelVisible: count > 0,
                label: Text('$count'),
                child: Icon(
                  Icons.bookmarks_rounded,
                  size: 24,
                  color: colors.primaryMain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  _CompassPainter({
    required this.rotationRad,
    required this.centered,
    required this.northColor,
    required this.armColor,
    required this.dotColor,
  });

  final double rotationRad;
  final bool centered;
  final Color northColor;
  final Color armColor;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final arm = size.width / 2;

    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..rotate(rotationRad);

    final armPaint = Paint()
      ..color = armColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // South / East / West arms (neutral).
    canvas
      ..drawLine(Offset.zero, Offset(0, arm), armPaint)
      ..drawLine(Offset.zero, Offset(arm, 0), armPaint)
      ..drawLine(Offset.zero, Offset(-arm, 0), armPaint);

    // North arm + arrow tip (red).
    final northPaint = Paint()
      ..color = northColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(0, -arm + 3), northPaint);

    final tip = ui.Path()
      ..moveTo(0, -arm - 1)
      ..lineTo(-3.5, -arm + 5)
      ..lineTo(3.5, -arm + 5)
      ..close();
    canvas
      ..drawPath(tip, Paint()..color = northColor)
      ..restore();

    // Centre dot: filled when centered on the user, hollow otherwise.
    if (centered) {
      canvas.drawCircle(center, 3.2, Paint()..color = dotColor);
    } else {
      canvas.drawCircle(
        center,
        3,
        Paint()
          ..color = dotColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(_CompassPainter old) =>
      old.rotationRad != rotationRad ||
      old.centered != centered ||
      old.northColor != northColor ||
      old.armColor != armColor ||
      old.dotColor != dotColor;
}
