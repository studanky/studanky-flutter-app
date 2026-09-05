import 'package:flutter/foundation.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_empty_state_controller.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_marker_state.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/user_location_state.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/platform_config.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

/// Immutable snapshot rendered by the map view.
@immutable
class MapPageViewState {
  const MapPageViewState({
    required this.markers,
    required this.platformConfig,
    required this.location,
    required this.emptyMode,
    required this.isOffline,
    required this.isLocating,
    required this.detailDocumentId,
    required this.detailMarker,
  });

  final MapMarkerState markers;
  final PlatformConfig platformConfig;
  final UserLocationState location;
  final MapEmptyOverlayMode emptyMode;
  final bool isOffline;
  final bool isLocating;
  final String? detailDocumentId;
  final SpringMarkerEntity? detailMarker;
}
