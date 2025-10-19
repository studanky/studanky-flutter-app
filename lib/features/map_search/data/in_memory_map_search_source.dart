import 'package:studanky_flutter_app/features/map_page/models/map_marker.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/models/map_search_result.dart';

/// Local search used as a fallback when a remote backend is not available.
class InMemoryMapSearchSource implements MapSearchSource {
  InMemoryMapSearchSource(this._markers);

  final List<MapMarker> _markers;

  @override
  Future<List<MapSearchResult>> search(String query) async {
    final normalised = query.trim().toLowerCase();
    if (normalised.isEmpty) return const [];
    return _markers
        .where(
          (marker) => (marker.label ?? '').toLowerCase().contains(normalised),
        )
        .map(
          (marker) => MapSearchResult(
            label:
                marker.label ??
                '${marker.position.latitude.toStringAsFixed(5)}, '
                    '${marker.position.longitude.toStringAsFixed(5)}',
            position: marker.position,
          ),
        )
        .toList(growable: false);
  }
}
