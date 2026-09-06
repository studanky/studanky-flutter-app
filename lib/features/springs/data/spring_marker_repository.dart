import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

/// Fetch policy and cache-coverage boundary for map markers.
abstract interface class SpringMarkerRepository {
  bool covers(SpringBounds bounds, {required String languageTag});

  bool hasDataFor(SpringBounds bounds, {required String languageTag});

  Future<ApiResult<List<SpringMarkerEntity>>> load(
    SpringBounds bounds, {
    required String languageTag,
  });
}
