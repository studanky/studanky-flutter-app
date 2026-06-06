import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/utils/api_guard.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/platform_config/data/platform_config_api.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/platform_config.dart';
import 'package:studanky_flutter_app/features/platform_config/mappers/platform_config_mapper.dart';

part 'platform_config_repository.g.dart';

abstract class PlatformConfigRepository {
  /// Fetches the live platform config, normalising errors into an
  /// [ApiResult.failure] so callers never see a raw `DioException`.
  Future<ApiResult<PlatformConfig>> fetch();
}

class PlatformConfigRepositoryImpl implements PlatformConfigRepository {
  PlatformConfigRepositoryImpl(this._api);

  final PlatformConfigApi _api;

  /// Populate the ranges component — Strapi v5 omits it otherwise
  /// (api-reference.md §3.4).
  static const Map<String, dynamic> _queries = <String, dynamic>{
    'populate[flow_scale_ranges]': true,
  };

  @override
  Future<ApiResult<PlatformConfig>> fetch() {
    return guardApiCall(() async {
      final response = await _api.fetch(_queries);
      return PlatformConfigMapper.fromDto(response.data);
    });
  }
}

@Riverpod(keepAlive: true)
PlatformConfigRepository platformConfigRepository(Ref ref) =>
    PlatformConfigRepositoryImpl(ref.watch(platformConfigApiProvider));
