import 'package:flutter_map/flutter_map.dart';
import 'package:studanky_flutter_app/features/map/data/map_marker_source.dart';
import 'package:studanky_flutter_app/features/map/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map/models/map_search_result.dart';

/// Fallback adapter that queries the entire marker source if no dedicated
/// search backend is configured.
class MapMarkerSourceAdapter implements MapSearchSource {
  MapMarkerSourceAdapter(this._source);

  final MapMarkerSource _source;

  @override
  Future<List<MapSearchResult>> search(String query) async {
    final normalised = query.trim().toLowerCase();
    if (normalised.isEmpty) return const [];

    final globalBounds = LatLngBounds.unsafe(
      north: LatLngBounds.maxLatitude,
      south: LatLngBounds.minLatitude,
      east: LatLngBounds.maxLongitude,
      west: LatLngBounds.minLongitude,
    );

    final markers = await _source.loadMarkers(globalBounds);
    return markers
        .where(
          (marker) => (marker.label ?? '').toLowerCase().contains(normalised),
        )
        .map(
          (marker) => MapSearchResult(
            label: marker.label ??
                '${marker.position.latitude.toStringAsFixed(5)}, '
                    '${marker.position.longitude.toStringAsFixed(5)}',
            position: marker.position,
          ),
        )
        .toList(growable: false);
  }
}
