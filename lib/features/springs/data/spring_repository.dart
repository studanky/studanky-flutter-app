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
  Future<ApiResult<List<SpringMarkerEntity>>> fetchMapMarkers({
    required SpringBounds bounds,
    required String languageTag,
  });

  /// Searches springs by canonical name for map autocomplete. [origin] enables
  /// nearest-first ordering and distance metadata on the backend.
  Future<ApiResult<List<SpringSearchResult>>> searchByName({
    required String query,
    required String languageTag,
    LatLng? origin,
    int limit = 5,
  });
}

class SpringRepositoryImpl implements SpringRepository {
  SpringRepositoryImpl(this._api);

  final SpringsApi _api;

  @override
  Future<ApiResult<List<SpringMarkerEntity>>> fetchMapMarkers({
    required SpringBounds bounds,
    required String languageTag,
  }) {
    // bbox order is minLng,minLat,maxLng,maxLat (api-reference.md §3.1).
    final bbox =
        '${bounds.west},${bounds.south},${bounds.east},${bounds.north}';

    return guardApiCall(() async {
      final response = await _api.getMap(bbox, languageTag);
      return response.data
          .map(SpringMapMarkerMapper.fromDto)
          .toList(growable: false);
    });
  }

  @override
  Future<ApiResult<List<SpringSearchResult>>> searchByName({
    required String query,
    required String languageTag,
    LatLng? origin,
    int limit = 5,
  }) {
    return guardApiCall(() async {
      final response = await _api.search(
        query,
        origin?.latitude,
        origin?.longitude,
        limit,
        languageTag,
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
