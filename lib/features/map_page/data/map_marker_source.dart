import 'package:flutter_map/flutter_map.dart';
import 'package:studanky_flutter_app/features/map_page/models/map_marker.dart';

/// Contract for loading markers that should be rendered inside a map viewport.
abstract class MapMarkerSource {
  Future<List<MapMarker>> loadMarkers(LatLngBounds bounds);
}

/// Simple in-memory source that filters a static collection by the
/// requested bounds.
class InMemoryMapMarkerSource implements MapMarkerSource {
  InMemoryMapMarkerSource({required List<MapMarker> markers})
    : _markers = markers;

  final List<MapMarker> _markers;

  /// Returns an immutable view of all markers held in memory.
  List<MapMarker> get allMarkers => List.unmodifiable(_markers);

  @override
  Future<List<MapMarker>> loadMarkers(LatLngBounds bounds) async {
    return _markers
        .where((marker) => bounds.contains(marker.position))
        .toList(growable: false);
  }
}
