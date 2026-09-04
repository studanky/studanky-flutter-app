import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/utils/api_guard.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/core/providers/shared_preferences_provider.dart';
import 'package:studanky_flutter_app/features/platform_config/data/platform_config_api.dart';
import 'package:studanky_flutter_app/features/platform_config/data/platform_config_cache.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/platform_config.dart';
import 'package:studanky_flutter_app/features/platform_config/mappers/platform_config_mapper.dart';

part 'platform_config_repository.g.dart';

abstract class PlatformConfigRepository {
  PlatformConfig loadCached();

  /// Fetches and persists the live platform config.
  Future<ApiResult<PlatformConfig>> refresh();
}

class PlatformConfigRepositoryImpl implements PlatformConfigRepository {
  PlatformConfigRepositoryImpl(this._api, this._cache);

  final PlatformConfigApi _api;
  final PlatformConfigCache _cache;

  /// Populate the ranges component — Strapi v5 omits it otherwise
  /// (api-reference.md §3.4).
  static const Map<String, dynamic> _queries = <String, dynamic>{
    'populate[flow_scale_ranges]': true,
  };

  @override
  PlatformConfig loadCached() => _cache.read() ?? PlatformConfig.fallback;

  @override
  Future<ApiResult<PlatformConfig>> refresh() {
    return guardApiCall(() async {
      final response = await _api.fetch(_queries);
      final config = PlatformConfigMapper.fromDto(response.data);
      await _cache.write(config);
      return config;
    });
  }
}

@Riverpod(keepAlive: true)
PlatformConfigRepository platformConfigRepository(Ref ref) {
  return PlatformConfigRepositoryImpl(
    ref.watch(platformConfigApiProvider),
    PlatformConfigCache(ref.watch(sharedPreferencesProvider)),
  );
}
