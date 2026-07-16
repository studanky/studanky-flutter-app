import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_search/data/composite_map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result_type.dart';

MapSearchResult _result(String label) => MapSearchResult(
  label: label,
  position: const LatLng(50, 14),
  type: MapSearchResultType.other,
);

class _FakeSearchSource implements MapSearchSource {
  _FakeSearchSource(this.results);

  final List<MapSearchResult> results;
  String? lastQuery;
  LatLng? lastOrigin;

  @override
  Future<List<MapSearchResult>> search(
    String query, {
    LatLng? origin,
    CancelToken? cancelToken,
  }) async {
    lastQuery = query;
    lastOrigin = origin;
    return results;
  }
}

class _ThrowingSearchSource implements MapSearchSource {
  @override
  Future<List<MapSearchResult>> search(
    String query, {
    LatLng? origin,
    CancelToken? cancelToken,
  }) {
    throw StateError('boom');
  }
}

void main() {
  test('keeps source order so springs can be prioritised', () async {
    final springSource = _FakeSearchSource([_result('spring')]);
    final mapySource = _FakeSearchSource([_result('mapy')]);
    final source = CompositeMapSearchSource([springSource, mapySource]);
    const origin = LatLng(50.1, 14.4);

    final results = await source.search('ostr', origin: origin);

    expect(results.map((result) => result.label), ['spring', 'mapy']);
    expect(springSource.lastQuery, 'ostr');
    expect(springSource.lastOrigin, origin);
    expect(mapySource.lastOrigin, origin);
  });

  test('returns later sources when one source fails', () async {
    final source = CompositeMapSearchSource([
      _ThrowingSearchSource(),
      _FakeSearchSource([_result('mapy')]),
    ]);

    final results = await source.search('ostr');

    expect(results.map((result) => result.label), ['mapy']);
  });

  test('rethrows when every source fails so the UI can show an error', () async {
    final source = CompositeMapSearchSource([
      _ThrowingSearchSource(),
      _ThrowingSearchSource(),
    ]);

    await expectLater(source.search('ostr'), throwsA(isA<StateError>()));
  });
}
