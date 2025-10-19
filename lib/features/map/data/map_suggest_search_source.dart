import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:studanky_flutter_app/features/map/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map/data/map_suggest_api_client.dart';
import 'package:studanky_flutter_app/features/map/models/map_search_result.dart';
import 'package:studanky_flutter_app/features/map/models/map_suggest_item.dart';
import 'package:studanky_flutter_app/features/map/models/map_suggest_query.dart';

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
        MapySuggestQuery(
          query: trimmed,
          language: language,
          limit: limit,
          types: types,
        ),
      );

      final results = suggest.items
          .map((MapSuggestItem item) {
            final name = item.name?.trim();
            final lat = item.position?.lat;
            final lon = item.position?.lon;
            if (name == null || name.isEmpty || lat == null || lon == null) {
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
      Logger().e(
        '[MapSearchSource] Mapy suggest request failed for "$trimmed"',
        error: error,
        stackTrace: stackTrace,
      );
      return const [];
    }
  }
}
