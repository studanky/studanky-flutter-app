import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/api/models/strapi_response.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_repository.dart';
import 'package:studanky_flutter_app/features/springs/data/springs_api.dart';
import 'package:studanky_flutter_app/features/springs/dtos/spring_map_marker_dto.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';

/// Records the bbox it was called with and returns a canned payload.
class _RecordingSpringsApi implements SpringsApi {
  _RecordingSpringsApi(this.response);

  final List<SpringMapMarkerDto> response;
  String? lastBbox;
  String? lastMapLanguageTag;
  String? lastQuery;
  double? lastLatitude;
  double? lastLongitude;
  int? lastLimit;
  String? lastLocale;

  @override
  Future<StrapiListResponse<SpringMapMarkerDto>> getMap(
    String bbox,
    String languageTag,
  ) async {
    lastBbox = bbox;
    lastMapLanguageTag = languageTag;
    return StrapiListResponse(data: response);
  }

  @override
  Future<StrapiListResponse<SpringMapMarkerDto>> search(
    String query,
    double? latitude,
    double? longitude,
    int limit,
    String languageTag,
  ) async {
    lastQuery = query;
    lastLatitude = latitude;
    lastLongitude = longitude;
    lastLimit = limit;
    lastLocale = languageTag;
    return StrapiListResponse(data: response);
  }
}

void main() {
  test(
    'builds the bbox as minLng,minLat,maxLng,maxLat and maps the data',
    () async {
      final api = _RecordingSpringsApi(const [
        SpringMapMarkerDto(
          documentId: 'd1',
          name: 'Spring',
          lat: 50.0,
          lng: 14.5,
          currentStatus: 'is_not_flowing',
          locale: 'cs',
        ),
      ]);
      final repository = SpringRepositoryImpl(api);

      final result = await repository.fetchMapMarkers(
        bounds: const SpringBounds(
          north: 50.2,
          south: 49.4,
          east: 16.0,
          west: 14.0,
        ),
        languageTag: 'en-AU',
      );

      // west, south, east, north
      expect(api.lastBbox, '14.0,49.4,16.0,50.2');
      expect(api.lastMapLanguageTag, 'en-AU');

      final springs = result.dataOrNull;
      expect(springs, isNotNull);
      expect(springs!.single.documentId, 'd1');
      expect(springs.single.status, SpringStatus.isNotFlowing);
      expect(springs.single.servedLanguageTag, 'cs');
    },
  );

  test('passes search parameters and keeps distance metadata', () async {
    final api = _RecordingSpringsApi(const [
      SpringMapMarkerDto(
        documentId: 'd1',
        name: 'Ostružná',
        lat: 50.18,
        lng: 17.05,
        currentStatus: 'is_flowing',
        locale: 'cs',
        distanceMeters: 2310,
      ),
    ]);
    final repository = SpringRepositoryImpl(api);

    final result = await repository.searchByName(
      query: 'ostr',
      languageTag: 'sr-Latn-RS',
      origin: const LatLng(50.1, 17.0),
      limit: 7,
    );

    expect(api.lastQuery, 'ostr');
    expect(api.lastLatitude, 50.1);
    expect(api.lastLongitude, 17.0);
    expect(api.lastLimit, 7);
    expect(api.lastLocale, 'sr-Latn-RS');

    final springs = result.dataOrNull;
    expect(springs, isNotNull);
    expect(springs!.single.spring.documentId, 'd1');
    expect(springs.single.spring.servedLanguageTag, 'cs');
    expect(springs.single.distanceMeters, 2310);
  });
}
