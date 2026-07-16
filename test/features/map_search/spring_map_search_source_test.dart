import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/api/exceptions/api_exceptions.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/map_search/data/spring_map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result_type.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_repository.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_search_result.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';

class _FakeSpringRepository implements SpringRepository {
  _FakeSpringRepository(this.searchResults);

  final List<SpringSearchResult> searchResults;
  int searchCalls = 0;
  String? lastQuery;
  LatLng? lastOrigin;
  int? lastLimit;
  String? lastLocale;

  @override
  Future<ApiResult<List<SpringMarkerEntity>>> fetchMapMarkers(
    SpringBounds bounds,
  ) async {
    return const ApiResult.success([]);
  }

  @override
  Future<ApiResult<List<SpringSearchResult>>> searchByName({
    required String query,
    LatLng? origin,
    int limit = 5,
    String? locale,
  }) async {
    searchCalls += 1;
    lastQuery = query;
    lastOrigin = origin;
    lastLimit = limit;
    lastLocale = locale;
    return ApiResult.success(searchResults);
  }
}

class _FailingSpringRepository implements SpringRepository {
  @override
  Future<ApiResult<List<SpringMarkerEntity>>> fetchMapMarkers(
    SpringBounds bounds,
  ) async {
    return const ApiResult.success([]);
  }

  @override
  Future<ApiResult<List<SpringSearchResult>>> searchByName({
    required String query,
    LatLng? origin,
    int limit = 5,
    String? locale,
  }) async {
    return const ApiResult<List<SpringSearchResult>>.failure(
      NetworkException(message: 'offline'),
    );
  }
}

void main() {
  test(
    'does not call the API for queries shorter than two characters',
    () async {
      final repository = _FakeSpringRepository(const []);
      final source = SpringMapSearchSource(
        repository: repository,
        languageCode: 'cs',
        springLabel: 'Studánka',
      );

      final results = await source.search('o');

      expect(results, isEmpty);
      expect(repository.searchCalls, 0);
    },
  );

  test(
    'maps springs to first-party search results with distance subtitle',
    () async {
      const spring = SpringMarkerEntity(
        documentId: 'd1',
        name: 'Ostružná',
        position: LatLng(50.18, 17.05),
        status: SpringStatus.isFlowing,
      );
      final repository = _FakeSpringRepository(const [
        SpringSearchResult(spring: spring, distanceMeters: 2310),
      ]);
      final source = SpringMapSearchSource(
        repository: repository,
        languageCode: 'cs',
        springLabel: 'Studánka',
        limit: 7,
      );
      const origin = LatLng(50.1, 17.0);

      final results = await source.search(' ostr ', origin: origin);

      expect(repository.lastQuery, 'ostr');
      expect(repository.lastOrigin, origin);
      expect(repository.lastLimit, 7);
      expect(repository.lastLocale, 'cs');

      expect(results, hasLength(1));
      expect(results.single.label, 'Ostružná');
      expect(results.single.type, MapSearchResultType.spring);
      expect(results.single.subtitle, 'Studánka • 2,3 km');
      expect(results.single.spring, spring);
    },
  );

  test('propagates repository failures so the UI can show an error', () async {
    final source = SpringMapSearchSource(
      repository: _FailingSpringRepository(),
      languageCode: 'cs',
      springLabel: 'Studánka',
    );

    await expectLater(source.search('ostr'), throwsA(isA<NetworkException>()));
  });
}
