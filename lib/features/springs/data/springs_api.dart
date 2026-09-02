import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/dio/dio_provider.dart';
import 'package:studanky_flutter_app/core/api/models/strapi_response.dart';
import 'package:studanky_flutter_app/features/springs/dtos/spring_map_marker_dto.dart';

part 'springs_api.g.dart';

/// Spring read endpoints. The map path is public (`auth:false`) and returns a
/// flat `{ data: [...] }` payload with no pagination meta (api-reference.md
/// §3.1), which [StrapiListResponse] models with `meta` left null.
@RestApi()
abstract class SpringsApi {
  factory SpringsApi(Dio dio, {String? baseUrl}) = _SpringsApi;

  /// [bbox] is `minLng,minLat,maxLng,maxLat`.
  ///
  /// [languageTag] deliberately remains the complete Flutter BCP-47 tag. The
  /// backend canonicalizes arbitrary requested tags, queries configured
  /// locales only, and falls back server-side; the client must not shorten a
  /// regional or script-aware tag to its base language.
  @GET(ApiConfig.springsMapEndpoint)
  Future<StrapiListResponse<SpringMapMarkerDto>> getMap(
    @Query('bbox') String bbox,
    @Query('locale') String languageTag,
  );

  @GET(ApiConfig.springsSearchEndpoint)
  Future<StrapiListResponse<SpringMapMarkerDto>> search(
    @Query('q') String query,
    @Query('lat') double? latitude,
    @Query('lng') double? longitude,
    @Query('limit') int limit,
    @Query('locale') String languageTag,
  );
}

@Riverpod(keepAlive: true)
SpringsApi springsApi(Ref ref) => SpringsApi(ref.watch(dioProvider));
