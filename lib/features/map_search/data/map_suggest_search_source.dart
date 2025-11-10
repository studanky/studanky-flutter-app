import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/features/map_search/bos/map_suggest_item_bo.dart';
import 'package:studanky_flutter_app/features/map_search/bos/map_suggest_query_bo.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_suggest_api_client.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';

/// Remote autocomplete backed by the Mapy.cz suggest API.
class MapSuggestSearchSource implements MapSearchSource {
  MapSuggestSearchSource({
    required this.apiClient,
    this.language = 'cs',
    this.limit = 5,
    this.types = const ['regional'], // For Adressess, Cities, Regions etc.
  });

  final MapSuggestApiClient apiClient;
  final String language;
  final int limit;
  final List<String> types;

  final _logger = Logger('MapSuggestSearchSource');
  final Map<String, List<MapSearchResult>> _cache = {};

  @override
  Future<List<MapSearchResult>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final cacheKey = trimmed.toLowerCase();
    final cached = _cache[cacheKey];
    if (cached != null) {
      return cached;
    }

    try {
      final suggest = await apiClient.fetch(
        MapySuggestQueryBO(
          query: trimmed,
          language: language,
          limit: limit,
          types: types,
        ),
      );

      final results = suggest.items
          .map((MapSuggestItemBO item) {
            final name = item.name.trim();
            final lat = item.position.lat;
            final lon = item.position.lon;
            if (name.isEmpty) {
              return null;
            }
            return MapSearchResult(
              label: name,
              position: LatLng(lat, lon),
              raw: item.toJson(),
            );
          })
          .whereType<MapSearchResult>()
          .toList(growable: false);

      _cache[cacheKey] = results;
      return results;
    } on DioException catch (error, stackTrace) {
      _logger.shout(
        'Mapy suggest request failed for "$trimmed"',
        error,
        stackTrace,
      );
      return const [];
    }
  }
}
