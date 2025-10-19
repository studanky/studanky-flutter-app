import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/config/mapy_config.dart';
import 'package:studanky_flutter_app/features/map/data/map_marker_source.dart';
import 'package:studanky_flutter_app/features/map/models/map_marker.dart';
import 'package:studanky_flutter_app/features/map/models/map_search_result.dart';
import 'package:studanky_flutter_app/features/map/models/mapy_suggest_item.dart';
import 'package:studanky_flutter_app/features/map/models/mapy_suggest_response.dart';

/// Contract implemented by all marker search backends.
abstract class MapSearchSource {
  Future<List<MapSearchResult>> search(String query);
}

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

/// Remote autocomplete backed by the Mapy.cz suggest API. Includes simple
/// in-memory caching keyed by the normalised query string.
class MapySuggestSearchSource implements MapSearchSource {
  MapySuggestSearchSource({
    required Dio client,
    required this.apiKey,
    this.language = 'cs',
    this.limit = 5,
    this.types = const ['regional.address'],
  }) : _client = client;

  final Dio _client;
  final String apiKey;
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
      final response = await _client.get<Map<String, dynamic>>(
        'https://${MapyConfig.suggestBaseUrl}/v1/suggest',
        queryParameters: <String, dynamic>{
          'lang': language,
          'limit': limit,
          'type': types.join(','),
          'apikey': apiKey,
          'query': trimmed,
        },
      );

      final data = response.data;
      if (data == null) {
        return const [];
      }

      final suggest = MapySuggestResponse.fromJson(data);
      final results = suggest.items
          .map((MapySuggestItem item) {
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
      debugPrint('Mapy suggest request failed: $error\n$stackTrace');
      return const [];
    }
  }
}

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
