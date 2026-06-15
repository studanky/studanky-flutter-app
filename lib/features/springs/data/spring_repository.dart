import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/utils/api_guard.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/springs/data/springs_api.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_search_result.dart';
import 'package:studanky_flutter_app/features/springs/mappers/spring_map_marker_mapper.dart';

part 'spring_repository.g.dart';

abstract class SpringRepository {
  /// Fetches the map markers inside [bounds], normalising errors into an
  /// [ApiResult.failure] so callers never see a raw `DioException`.
  Future<ApiResult<List<SpringMarkerEntity>>> fetchMapMarkers(
    SpringBounds bounds,
  );

  /// Searches springs by localized name for map autocomplete. [origin] enables
  /// nearest-first ordering and distance metadata on the backend.
  Future<ApiResult<List<SpringSearchResult>>> searchByName({
    required String query,
    LatLng? origin,
    int limit = 5,
    String? locale,
  });
}

class SpringRepositoryImpl implements SpringRepository {
  SpringRepositoryImpl(this._api);

  final SpringsApi _api;

  @override
  Future<ApiResult<List<SpringMarkerEntity>>> fetchMapMarkers(
    SpringBounds bounds,
  ) {
    // bbox order is minLng,minLat,maxLng,maxLat (api-reference.md §3.1).
    final bbox =
        '${bounds.west},${bounds.south},${bounds.east},${bounds.north}';

    return guardApiCall(() async {
      final response = await _api.getMap(bbox);
      return response.data
          .map(SpringMapMarkerMapper.fromDto)
          .toList(growable: false);
    });
  }

  @override
  Future<ApiResult<List<SpringSearchResult>>> searchByName({
    required String query,
    LatLng? origin,
    int limit = 5,
    String? locale,
  }) {
    return guardApiCall(() async {
      final response = await _api.search(
        query,
        origin?.latitude,
        origin?.longitude,
        limit,
        locale,
      );
      return response.data
          .map(
            (dto) => SpringSearchResult(
              spring: SpringMapMarkerMapper.fromDto(dto),
              distanceMeters: dto.distanceMeters,
            ),
          )
          .toList(growable: false);
    });
  }
}

@Riverpod(keepAlive: true)
SpringRepository springRepository(Ref ref) =>
    SpringRepositoryImpl(ref.watch(springsApiProvider));
