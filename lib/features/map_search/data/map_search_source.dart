import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';

/// Contract implemented by all marker search backends.
abstract class MapSearchSource {
  /// [cancelToken] aborts an in-flight request once a newer keystroke (or a
  /// clear/selection) supersedes it. Only remote, third-party backends need to
  /// honour it; cheap first-party sources may ignore it.
  Future<List<MapSearchResult>> search(
    String query, {
    LatLng? origin,
    CancelToken? cancelToken,
  });
}
