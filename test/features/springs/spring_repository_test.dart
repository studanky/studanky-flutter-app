import 'package:flutter_test/flutter_test.dart';
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

  @override
  Future<StrapiListResponse<SpringMapMarkerDto>> getMap(String bbox) async {
    lastBbox = bbox;
    return StrapiListResponse(data: response);
  }
}

void main() {
  test('builds the bbox as minLng,minLat,maxLng,maxLat and maps the data', () async {
    final api = _RecordingSpringsApi(const [
      SpringMapMarkerDto(
        documentId: 'd1',
        name: 'Spring',
        lat: 50.0,
        lng: 14.5,
        currentStatus: 'is_not_flowing',
      ),
    ]);
    final repository = SpringRepositoryImpl(api);

    final result = await repository.fetchMapMarkers(
      const SpringBounds(north: 50.2, south: 49.4, east: 16.0, west: 14.0),
    );

    // west, south, east, north
    expect(api.lastBbox, '14.0,49.4,16.0,50.2');

    final springs = result.dataOrNull;
    expect(springs, isNotNull);
    expect(springs!.single.documentId, 'd1');
    expect(springs.single.status, SpringStatus.isNotFlowing);
  });
}
