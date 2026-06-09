import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/utils/api_guard.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/spring_detail/data/spring_detail_api.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/report_page.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/spring_detail.dart';
import 'package:studanky_flutter_app/features/spring_detail/mappers/report_mapper.dart';
import 'package:studanky_flutter_app/features/spring_detail/mappers/spring_detail_mapper.dart';

part 'spring_detail_repository.g.dart';

abstract class SpringDetailRepository {
  /// Full detail for [documentId]. Populates `photo` and `owner`; pass [locale]
  /// to request a localized `name`/`description` (api-reference.md §3.2).
  Future<ApiResult<SpringDetail>> fetchDetail(
    String documentId, {
    String? locale,
  });

  /// One page of report history, newest first (api-reference.md §3.3).
  Future<ApiResult<ReportPage>> fetchReports(
    String documentId, {
    required int page,
    int pageSize,
  });
}

class SpringDetailRepositoryImpl implements SpringDetailRepository {
  SpringDetailRepositoryImpl(this._api);

  final SpringDetailApi _api;

  @override
  Future<ApiResult<SpringDetail>> fetchDetail(
    String documentId, {
    String? locale,
  }) {
    final queries = <String, dynamic>{
      'populate[photo]': true,
      'populate[owner]': true,
      'locale': ?locale,
    };

    return guardApiCall(() async {
      final response = await _api.getDetail(documentId, queries);
      return SpringDetailMapper.fromDto(response.data);
    });
  }

  @override
  Future<ApiResult<ReportPage>> fetchReports(
    String documentId, {
    required int page,
    int pageSize = ApiConfig.reportsPageSize,
  }) {
    return guardApiCall(() async {
      final response = await _api.getReports(documentId, page, pageSize);
      return ReportMapper.pageFromResponse(response, requestedPage: page);
    });
  }
}

@Riverpod(keepAlive: true)
SpringDetailRepository springDetailRepository(Ref ref) =>
    SpringDetailRepositoryImpl(ref.watch(springDetailApiProvider));
