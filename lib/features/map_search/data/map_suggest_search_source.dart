import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_suggest_api.dart';
import 'package:studanky_flutter_app/features/map_search/dtos/map_suggest_item_dto.dart';
import 'package:studanky_flutter_app/features/map_search/dtos/map_suggest_language_dto.dart';
import 'package:studanky_flutter_app/features/map_search/dtos/map_suggest_query_dto.dart';
import 'package:studanky_flutter_app/features/map_search/dtos/map_suggest_type_dto.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result_type.dart';

/// Remote autocomplete backed by the Mapy.cz suggest API.
class MapSuggestSearchSource implements MapSearchSource {
  MapSuggestSearchSource({
    required this.api,
    required this.apiKey,
    required this.languageCode,
    this.limit = 5,
  });

  final MapSuggestApi api;
  final String apiKey;
  final String languageCode;
  final int limit;

  static const List<MapSuggestTypeDto> types = <MapSuggestTypeDto>[
    MapSuggestTypeDto.regionalMunicipality,
    MapSuggestTypeDto.regionalRegion,
    MapSuggestTypeDto.regionalAddress,
    MapSuggestTypeDto.poi,
  ];

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
      final query = MapySuggestQueryDto(
        query: trimmed,
        language: MapSuggestLanguageDto.fromCode(languageCode),
        limit: limit,
        types: types,
      );
      final suggest = await api.suggest(query.toQueryParameters(apiKey));

      final results = suggest.items
          .map((MapSuggestItemDto item) {
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
              bounds: _boundsFromBbox(item.bbox),
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

  /// Converts the suggest `[minLon, minLat, maxLon, maxLat]` bbox into
  /// south-west / north-east corners; returns null when absent or malformed.
  static MapSearchBounds? _boundsFromBbox(List<double>? bbox) {
    if (bbox == null || bbox.length != 4) return null;
    final (minLon, minLat, maxLon, maxLat) = (
      bbox[0],
      bbox[1],
      bbox[2],
      bbox[3],
    );
    return MapSearchBounds(
      southWest: LatLng(minLat, minLon),
      northEast: LatLng(maxLat, maxLon),
    );
  }

  static MapSearchResultType _mapType(MapSuggestTypeDto typeDto) {
    switch (typeDto) {
      case MapSuggestTypeDto.regional:
        return MapSearchResultType.regional;
      case MapSuggestTypeDto.regionalCountry:
        return MapSearchResultType.regionalCountry;
      case MapSuggestTypeDto.regionalRegion:
        return MapSearchResultType.regionalRegion;
      case MapSuggestTypeDto.regionalMunicipality:
        return MapSearchResultType.regionalMunicipality;
      case MapSuggestTypeDto.regionalMunicipalityPart:
        return MapSearchResultType.regionalMunicipalityPart;
      case MapSuggestTypeDto.regionalStreet:
        return MapSearchResultType.regionalStreet;
      case MapSuggestTypeDto.regionalAddress:
        return MapSearchResultType.regionalAddress;
      case MapSuggestTypeDto.poi:
        return MapSearchResultType.poi;
      case MapSuggestTypeDto.coordinate:
        return MapSearchResultType.coordinate;
    }
  }
}
