import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/core/api/models/strapi_response.dart';
import 'package:studanky_flutter_app/features/spring_detail/data/spring_detail_api.dart';
import 'package:studanky_flutter_app/features/spring_detail/data/spring_detail_repository.dart';
import 'package:studanky_flutter_app/features/spring_detail/dtos/report_dto.dart';
import 'package:studanky_flutter_app/features/spring_detail/dtos/spring_detail_dto.dart';
import 'package:studanky_flutter_app/features/spring_detail/providers/spring_detail_provider.dart';

class _RecordingSpringDetailApi implements SpringDetailApi {
  _RecordingSpringDetailApi(this.detail);

  final SpringDetailDto detail;
  int detailCalls = 0;
  String? detailDocumentId;
  Map<String, dynamic>? detailQueries;
  final List<Map<String, dynamic>> detailQueryHistory = [];
  String? reportsDocumentId;
  int? reportsPage;
  int? reportsPageSize;

  @override
  Future<StrapiSingleResponse<SpringDetailDto>> getDetail(
    String documentId,
    Map<String, dynamic> queries,
  ) async {
    detailCalls++;
    detailDocumentId = documentId;
    detailQueries = Map<String, dynamic>.of(queries);
    detailQueryHistory.add(Map<String, dynamic>.of(queries));
    return StrapiSingleResponse(data: detail);
  }

  @override
  Future<StrapiListResponse<ReportDto>> getReports(
    String documentId,
    int page,
    int pageSize,
  ) async {
    reportsDocumentId = documentId;
    reportsPage = page;
    reportsPageSize = pageSize;
    return const StrapiListResponse(
      meta: StrapiMeta(
        pagination: StrapiPagination(
          page: 2,
          pageSize: 20,
          pageCount: 3,
          total: 41,
        ),
      ),
    );
  }
}

void main() {
  test(
    'passes full locale with populate and accepts backend fallback',
    () async {
      final api = _RecordingSpringDetailApi(
        const SpringDetailDto(
          documentId: 'spring-1',
          name: 'Ostružná',
          description: null,
          lat: 50.18,
          lng: 17.05,
          currentStatus: 'is_flowing',
          locale: 'cs',
        ),
      );
      final repository = SpringDetailRepositoryImpl(api);

      final result = await repository.fetchDetail(
        documentId: 'spring-1',
        languageTag: 'en-AU',
      );

      expect(api.detailCalls, 1);
      expect(api.detailDocumentId, 'spring-1');
      expect(api.detailQueries, {
        'populate[photo]': true,
        'populate[owner]': true,
        'locale': 'en-AU',
      });
      expect(result.dataOrNull?.description, isNull);
      expect(result.dataOrNull?.servedLanguageTag, 'cs');
    },
  );

  test('keeps reports pagination unchanged and locale-free', () async {
    final api = _RecordingSpringDetailApi(
      const SpringDetailDto(
        documentId: 'spring-1',
        name: 'Ostružná',
        lat: 50.18,
        lng: 17.05,
        currentStatus: 'is_flowing',
      ),
    );
    final repository = SpringDetailRepositoryImpl(api);

    final result = await repository.fetchReports(
      'spring-1',
      page: 2,
      pageSize: 20,
    );

    expect(api.reportsDocumentId, 'spring-1');
    expect(api.reportsPage, 2);
    expect(api.reportsPageSize, 20);
    expect(result.dataOrNull?.page, 2);
    expect(result.dataOrNull?.pageCount, 3);
  });

  test('parses a pre-1.5.0 detail without locale', () {
    final dto = SpringDetailDto.fromJson(const {
      'documentId': 'spring-1',
      'name': 'Ostružná',
      'description': null,
      'lat': 50.18,
      'lng': 17.05,
      'current_status': 'is_flowing',
    });

    expect(dto.locale, isNull);
    expect(dto.description, isNull);
  });

  test('detail provider cache key includes the requested locale', () async {
    final api = _RecordingSpringDetailApi(
      const SpringDetailDto(
        documentId: 'spring-1',
        name: 'Ostružná',
        lat: 50.18,
        lng: 17.05,
        currentStatus: 'is_flowing',
        locale: 'cs',
      ),
    );
    final repository = SpringDetailRepositoryImpl(api);
    final container = ProviderContainer(
      overrides: [springDetailRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final englishAu = springDetailProvider('spring-1', languageTag: 'en-AU');
    final englishUs = springDetailProvider('spring-1', languageTag: 'en-US');
    container
      ..listen(englishAu, (_, _) {})
      ..listen(englishUs, (_, _) {});

    await Future.wait([
      container.read(englishAu.future),
      container.read(englishUs.future),
    ]);

    expect(api.detailCalls, 2);
    expect(
      api.detailQueryHistory.map((queries) => queries['locale']),
      containsAll(['en-AU', 'en-US']),
    );
  });
}
