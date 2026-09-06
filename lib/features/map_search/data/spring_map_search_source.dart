import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result_type.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_repository.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_search_result.dart';

/// First-party autocomplete backed by `GET /api/springs/search`.
class SpringMapSearchSource implements MapSearchSource {
  SpringMapSearchSource({
    required this.repository,
    required this.languageTag,
    this.limit = 5,
  });

  static const int _minQueryLength = 2;

  /// Upper bound on cached first-party queries. The source is kept alive for the
  /// app session, so cap the map to stop it growing without limit; oldest
  /// entries are evicted first (FIFO — plenty for autocomplete reuse).
  static const int _maxCacheEntries = 64;

  final SpringRepository repository;
  final String languageTag;
  final int limit;

  final _logger = Logger('SpringMapSearchSource');
  final Map<String, List<MapSearchResult>> _cache = {};

  @override
  Future<List<MapSearchResult>> search(
    String query, {
    LatLng? origin,
    // Ignored on purpose: this first-party lookup is cheap and isn't threaded
    // through the repository, so only the remote Mapy source honours the token.
    CancelToken? cancelToken,
  }) async {
    final trimmed = query.trim();
    if (trimmed.length < _minQueryLength) return const [];

    // The source instance is already scoped to [languageTag].
    final cacheKey = [
      trimmed.toLowerCase(),
      origin?.latitude.toStringAsFixed(4),
      origin?.longitude.toStringAsFixed(4),
    ].join('|');
    final cached = _cache[cacheKey];
    if (cached != null) return cached;

    final result = await repository.searchByName(
      query: trimmed,
      languageTag: languageTag,
      origin: origin,
      limit: limit,
    );

    switch (result) {
      case Success(:final data):
        final mapped = data.map(_toMapSearchResult).toList(growable: false);
        if (_cache.length >= _maxCacheEntries) {
          _cache.remove(_cache.keys.first);
        }
        _cache[cacheKey] = mapped;
        return mapped;
      case Failure(:final exception):
        _logger.warning('Spring search failed for "$trimmed"', exception);
        // Propagate so the composite can tell a genuine failure (e.g. offline)
        // apart from a legitimately empty result set.
        throw exception;
    }
  }

  MapSearchResult _toMapSearchResult(SpringSearchResult result) {
    final spring = result.spring;
    return MapSearchResult(
      label: spring.name,
      position: spring.position,
      type: MapSearchResultType.spring,
      spring: spring,
      distanceMeters: result.distanceMeters,
    );
  }
}
