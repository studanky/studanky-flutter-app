import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/dio/dio_provider.dart';
import 'package:studanky_flutter_app/core/api/models/strapi_response.dart';
import 'package:studanky_flutter_app/features/platform_config/dtos/platform_config_dto.dart';

part 'platform_config_api.g.dart';

/// Strapi core handler for the platform-config single type.
///
/// The endpoint requires the Public role to have `platform-config.find`
/// enabled, otherwise it returns 403 (api-reference.md §1 Authentication).
@RestApi()
abstract class PlatformConfigApi {
  factory PlatformConfigApi(Dio dio, {String? baseUrl}) = _PlatformConfigApi;

  /// Pass `populate[flow_scale_ranges]=true` (the repository does) to receive
  /// the ranges component — Strapi v5 omits relations/components otherwise.
  @GET(ApiConfig.platformConfigEndpoint)
  Future<StrapiSingleResponse<PlatformConfigDto>> fetch(
    @Queries() Map<String, dynamic> queries,
  );
}

@Riverpod(keepAlive: true)
PlatformConfigApi platformConfigApi(Ref ref) =>
    PlatformConfigApi(ref.watch(dioProvider));
