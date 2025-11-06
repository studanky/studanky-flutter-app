import 'package:studanky_flutter_app/core/repositories/map_marker_repository.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_marker_entity.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';

class MapMarkerRepositoryAdapter implements MapSearchSource {
  MapMarkerRepositoryAdapter(this._repository);

  final MapMarkerRepository _repository;
  List<MapMarkerEntity>? _cache;

  Future<List<MapMarkerEntity>> _markers() async {
    _cache ??= await _repository.fetchAllMarkers();
    return _cache!;
  }

  @override
  Future<List<MapSearchResult>> search(String query) async {
    final normalised = query.trim().toLowerCase();
    if (normalised.isEmpty) return const [];

    final markers = await _markers();
    return markers
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
