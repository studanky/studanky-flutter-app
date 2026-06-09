import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/dio/dio_provider.dart';
import 'package:studanky_flutter_app/core/api/models/strapi_response.dart';
import 'package:studanky_flutter_app/features/spring_detail/dtos/report_dto.dart';
import 'package:studanky_flutter_app/features/spring_detail/dtos/spring_detail_dto.dart';

part 'spring_detail_api.g.dart';

/// Spring detail + report history endpoints (api-reference.md §3.2–3.3).
///
/// Detail is a Strapi core handler (gated by Public `spring.findOne`) returning
/// the standard `{ data, meta }` shape; reports is a custom public endpoint
/// returning a flat list with `meta.pagination`.
@RestApi()
abstract class SpringDetailApi {
  factory SpringDetailApi(Dio dio, {String? baseUrl}) = _SpringDetailApi;

  @GET('${ApiConfig.springsEndpoint}/{documentId}')
  Future<StrapiSingleResponse<SpringDetailDto>> getDetail(
    @Path('documentId') String documentId,
    @Queries() Map<String, dynamic> queries,
  );

  @GET('${ApiConfig.springsEndpoint}/{documentId}/reports')
  Future<StrapiListResponse<ReportDto>> getReports(
    @Path('documentId') String documentId,
    @Query('page') int page,
    @Query('pageSize') int pageSize,
  );
}

@Riverpod(keepAlive: true)
SpringDetailApi springDetailApi(Ref ref) =>
    SpringDetailApi(ref.watch(dioProvider));
