import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';

/// Presentation-facing search boundary. Transport cancellation stays hidden
/// in the data layer.
abstract interface class MapSearchRepository {
  Future<List<MapSearchResult>> search(String query, {LatLng? origin});

  void cancel();
}

class MapSearchRepositoryImpl implements MapSearchRepository {
  MapSearchRepositoryImpl(this._source);

  final MapSearchSource _source;
  CancelToken? _inFlightRequest;

  @override
  Future<List<MapSearchResult>> search(String query, {LatLng? origin}) async {
    cancel();
    final cancelToken = CancelToken();
    _inFlightRequest = cancelToken;
    try {
      return await _source.search(
        query,
        origin: origin,
        cancelToken: cancelToken,
      );
    } finally {
      if (identical(_inFlightRequest, cancelToken)) _inFlightRequest = null;
    }
  }

  @override
  void cancel() {
    _inFlightRequest?.cancel();
    _inFlightRequest = null;
  }
}
