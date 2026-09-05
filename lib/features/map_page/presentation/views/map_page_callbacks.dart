import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

/// User and map events forwarded by the map view to its stateful host.
@immutable
class MapPageCallbacks {
  const MapPageCallbacks({
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
  });

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
}
