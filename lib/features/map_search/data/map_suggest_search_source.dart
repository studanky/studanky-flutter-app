import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/features/map_search/bos/map_suggest_item_bo.dart';
import 'package:studanky_flutter_app/features/map_search/bos/map_suggest_item_type_bo.dart';
import 'package:studanky_flutter_app/features/map_search/bos/map_suggest_query_bo.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_suggest_api_client.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result_type.dart';

/// Remote autocomplete backed by the Mapy.cz suggest API.
class MapSuggestSearchSource implements MapSearchSource {
  MapSuggestSearchSource({
    required this.apiClient,
    required this.languageCode,
    this.limit = 5,
  }) {
    _language = MapSuggestLanguageBO.fromCode(languageCode);
  }

  final MapSuggestApiClient apiClient;
  final String languageCode;
  final int limit;

  static const List<MapSuggestTypeBO> types = <MapSuggestTypeBO>[
    MapSuggestTypeBO.regionalMunicipality,
    MapSuggestTypeBO.regionalRegion,
    MapSuggestTypeBO.regionalAddress,
    MapSuggestTypeBO.poi,
  ];

  final _logger = Logger('MapSuggestSearchSource');
  final Map<String, List<MapSearchResult>> _cache = {};
  late MapSuggestLanguageBO _language;

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
          language: _language,
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
              type: _mapType(item.type),
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

  static MapSearchResultType _mapType(MapSuggestItemTypeBo typeBo) {
    switch (typeBo) {
      case MapSuggestItemTypeBo.regional:
        return MapSearchResultType.regional;
      case MapSuggestItemTypeBo.regionalCountry:
        return MapSearchResultType.regionalCountry;
      case MapSuggestItemTypeBo.regionalRegion:
        return MapSearchResultType.regionalRegion;
      case MapSuggestItemTypeBo.regionalMunicipality:
        return MapSearchResultType.regionalMunicipality;
      case MapSuggestItemTypeBo.regionalMunicipalityPart:
        return MapSearchResultType.regionalMunicipalityPart;
      case MapSuggestItemTypeBo.regionalStreet:
        return MapSearchResultType.regionalStreet;
      case MapSuggestItemTypeBo.regionalAddress:
        return MapSearchResultType.regionalAddress;
      case MapSuggestItemTypeBo.poi:
        return MapSearchResultType.poi;
      case MapSuggestItemTypeBo.coordinate:
        return MapSearchResultType.coordinate;
    }
  }
}
