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

/// Remote autocomplete backed by the Mapy.com suggest API.
///
/// Deliberately holds **no result cache**: Mapy.com's terms of use forbid
/// storing or caching API function results (§4.6.2). Relevance and fewer
/// requests come instead from location biasing ([_formatPreferNear]), a
/// minimum query length, and upstream debouncing. Superseded in-flight
/// requests are additionally cancelled so the client stops waiting for
/// outdated results — the caller supplies the `cancelToken`, so a single owner
/// can also abort on backspace-to-short, clear, and selection.
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

  /// Skip single-character queries: too broad to be useful and a needless
  /// request. Matches `SpringMapSearchSource`'s threshold.
  static const int _minQueryLength = 2;

  /// Radius in metres of the `preferNear` preference circle around the map
  /// centre — wide enough to cover the visible region without hard-excluding a
  /// named place just outside it (the bias is a soft ranking hint). Tunable.
  static const int _preferNearPrecisionMeters = 10000;

  static const List<MapSuggestTypeDto> types = <MapSuggestTypeDto>[
    MapSuggestTypeDto.regionalMunicipality,
    MapSuggestTypeDto.regionalRegion,
    MapSuggestTypeDto.regionalAddress,
    MapSuggestTypeDto.poi,
  ];

  final _logger = Logger('MapSuggestSearchSource');

  @override
  Future<List<MapSearchResult>> search(
    String query, {
    LatLng? origin,
    CancelToken? cancelToken,
  }) async {
    final trimmed = query.trim();
    if (trimmed.length < _minQueryLength) return const [];

    try {
      final suggestQuery = MapySuggestQueryDto(
        query: trimmed,
        language: MapSuggestLanguageDto.fromCode(languageCode),
        limit: limit,
        types: types,
        preferNear: origin == null ? null : _formatPreferNear(origin),
        preferNearPrecision: origin == null ? null : _preferNearPrecisionMeters,
      );
      final suggest = await api.suggest(
        suggestQuery.toQueryParameters(apiKey),
        cancelToken: cancelToken,
      );

      return suggest.items
          .map((MapSuggestItemDto item) {
            final name = item.name.trim();
            final lat = item.position.lat;
            final lon = item.position.lon;
            if (name.isEmpty) {
              return null;
            }
            final location = item.location?.trim();
            return MapSearchResult(
              label: name,
              position: LatLng(lat, lon),
              type: _mapType(item.type),
              subtitle: (location == null || location.isEmpty)
                  ? null
                  : location,
              bounds: _boundsFromBbox(item.bbox),
            );
          })
          .whereType<MapSearchResult>()
          .toList(growable: false);
    } on DioException catch (error, stackTrace) {
      // A superseded request cancelled on purpose isn't a failure — the newer
      // request will deliver results, so stay quiet and yield nothing.
      if (CancelToken.isCancel(error)) return const [];
      _logger.warning(
        'Mapy suggest request failed for "$trimmed"',
        error,
        stackTrace,
      );
      // Surface real failures so the composite/UI can show an error state
      // instead of a misleading "no results".
      rethrow;
    }
  }

  /// Mapy.com's `preferNear` expects `"{lon},{lat}"` (longitude first). Six
  /// decimals is ~0.1 m — far finer than needed and keeps the URL short.
  static String _formatPreferNear(LatLng origin) =>
      '${origin.longitude.toStringAsFixed(6)},'
      '${origin.latitude.toStringAsFixed(6)}';

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
