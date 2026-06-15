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
  Future<List<MapSearchResult>> search(String query, {LatLng? origin}) async {
    final batches = await Future.wait(
      sources.map((source) => _safeSearch(source, query, origin)),
    );
    return [for (final batch in batches) ...batch];
  }

  Future<List<MapSearchResult>> _safeSearch(
    MapSearchSource source,
    String query,
    LatLng? origin,
  ) async {
    try {
      return await source.search(query, origin: origin);
    } catch (error, stackTrace) {
      _logger.warning(
        'Search source ${source.runtimeType} failed for "$query"',
        error,
        stackTrace,
      );
      return const [];
    }
  }
}
