import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/config/mapy_config.dart';
import 'package:studanky_flutter_app/features/map/data/map_marker_source.dart';
import 'package:studanky_flutter_app/features/map/models/map_marker.dart';
import 'package:studanky_flutter_app/features/map/models/map_search_result.dart';

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
    required http.Client client,
    required this.apiKey,
    this.language = 'cs',
    this.limit = 5,
    this.types = const ['regional.address'],
  }) : _client = client;

  final http.Client _client;
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

    final uri =
        Uri.https(MapyConfig.suggestBaseUrl, '/v1/suggest', <String, String>{
          'lang': language,
          'limit': '$limit',
          'type': types.join(','),
          'apikey': apiKey,
          'query': trimmed,
        });

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        debugPrint(
          'Mapy suggest request failed with status ${response.statusCode}',
        );
        return const [];
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final items = (decoded['items'] as List?) ?? const [];
      final results = <MapSearchResult>[];

      for (final item in items) {
        if (item is! Map<String, dynamic>) continue;
        final name = (item['name'] as String?)?.trim();
        final position = item['position'];
        if (name == null || name.isEmpty || position is! Map) continue;

        final lat = _parseCoordinate(position['lat'] ?? position['latitude']);
        final lon = _parseCoordinate(position['lon'] ?? position['longitude']);
        if (lat == null || lon == null) continue;

        results.add(
          MapSearchResult(label: name, position: LatLng(lat, lon), raw: item),
        );
      }

      _cache[cacheKey] = results;
      return results;
    } catch (error, stackTrace) {
      debugPrint('Mapy suggest request failed: $error\n$stackTrace');
      return const [];
    }
  }

  static double? _parseCoordinate(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
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
