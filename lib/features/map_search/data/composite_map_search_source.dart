import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';

/// Runs multiple autocomplete backends and keeps their configured order.
class CompositeMapSearchSource implements MapSearchSource {
  CompositeMapSearchSource(this.sources);

  final List<MapSearchSource> sources;
  final _logger = Logger('CompositeMapSearchSource');

  @override
  Future<List<MapSearchResult>> search(
    String query, {
    LatLng? origin,
    CancelToken? cancelToken,
  }) async {
    final outcomes = await Future.wait(
      sources.map((source) => _runSource(source, query, origin, cancelToken)),
    );

    final merged = <MapSearchResult>[];
    var anySucceeded = false;
    Object? firstError;
    StackTrace? firstStackTrace;

    for (final outcome in outcomes) {
      final results = outcome.results;
      if (results != null) {
        anySucceeded = true;
        merged.addAll(results);
      } else {
        firstError ??= outcome.error;
        firstStackTrace ??= outcome.stackTrace;
      }
    }

    // A partial failure still returns whatever the healthy sources produced.
    // Only when *every* backend failed (e.g. offline) do we surface the error,
    // so the UI shows a real error state instead of a misleading empty list.
    if (!anySucceeded && firstError != null) {
      Error.throwWithStackTrace(
        firstError,
        firstStackTrace ?? StackTrace.current,
      );
    }

    return merged;
  }

  Future<({List<MapSearchResult>? results, Object? error, StackTrace? stackTrace})>
  _runSource(
    MapSearchSource source,
    String query,
    LatLng? origin,
    CancelToken? cancelToken,
  ) async {
    try {
      final results = await source.search(
        query,
        origin: origin,
        cancelToken: cancelToken,
      );
      return (results: results, error: null, stackTrace: null);
    } catch (error, stackTrace) {
      _logger.warning(
        'Search source ${source.runtimeType} failed for "$query"',
        error,
        stackTrace,
      );
      return (results: null, error: error, stackTrace: stackTrace);
    }
  }
}
