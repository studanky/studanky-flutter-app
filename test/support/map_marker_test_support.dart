import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/map_page/providers/map_marker_provider.dart'
    as map_marker_providers;
import 'package:studanky_flutter_app/features/springs/data/cached_spring_marker_repository.dart'
    as marker_repositories;
import 'package:studanky_flutter_app/features/springs/data/spring_marker_repository.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_repository.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_search_result.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';
import 'package:studanky_flutter_app/features/springs/providers/spring_markers_provider.dart'
    as spring_marker_providers;

const testLanguageTag = 'cs';
final testMapMarkerProvider = map_marker_providers.mapMarkerProvider;
final testSpringMarkersProvider = spring_marker_providers.springMarkersProvider;
final testSpringMarkerRepositoryProvider =
    marker_repositories.springMarkerRepositoryProvider;

extension MapMarkerNotifierTestApi on map_marker_providers.MapMarkerNotifier {
  Future<void> reportCameraForTest(
    LatLngBounds bounds,
    double zoom, {
    String? tag,
  }) => onCameraChanged(bounds, zoom, languageTag: tag ?? testLanguageTag);

  Future<void> refreshForTest({String? tag}) =>
      refreshVisible(languageTag: tag ?? testLanguageTag);
}

SpringMarkerEntity spring(String id, double lat, double lng) =>
    SpringMarkerEntity(
      documentId: id,
      name: id,
      position: LatLng(lat, lng),
      status: SpringStatus.unknown,
    );

final prague = spring('a', 50.080, 14.420);
final pragueNear = spring('b', 50.081, 14.421);
final zdar = spring('c', 49.563, 15.940);
final praguePaddingRing = spring('padding', 49.98, 14.42);

final wideBounds = LatLngBounds(
  const LatLng(50.2, 16.0),
  const LatLng(49.4, 14.0),
);

final pragueBounds = LatLngBounds(
  const LatLng(50.15, 14.6),
  const LatLng(50.00, 14.30),
);

final pragueBoundsNudged = LatLngBounds(
  const LatLng(50.16, 14.61),
  const LatLng(50.01, 14.31),
);

class FakeSpringRepository implements SpringRepository {
  FakeSpringRepository(this.springs, {this.gate, this.gateOnFetch = 1});

  List<SpringMarkerEntity> springs;
  final Future<void>? gate;
  final int gateOnFetch;
  bool _gatePassed = false;
  int fetchCount = 0;
  final List<String> requestedLanguageTags = [];

  @override
  Future<ApiResult<List<SpringMarkerEntity>>> fetchMapMarkers({
    required SpringBounds bounds,
    required String languageTag,
  }) async {
    fetchCount++;
    requestedLanguageTags.add(languageTag);
    if (gate != null && !_gatePassed && fetchCount == gateOnFetch) {
      _gatePassed = true;
      await gate;
    }
    return ApiResult.success(
      springs
          .where(
            (item) => bounds.containsPosition(
              latitude: item.position.latitude,
              longitude: item.position.longitude,
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<ApiResult<List<SpringSearchResult>>> searchByName({
    required String query,
    required String languageTag,
    LatLng? origin,
    int limit = 5,
  }) async => const ApiResult.success([]);
}

class LocaleControlledSpringRepository implements SpringRepository {
  final Map<String, Completer<ApiResult<List<SpringMarkerEntity>>>> requests =
      {};

  @override
  Future<ApiResult<List<SpringMarkerEntity>>> fetchMapMarkers({
    required SpringBounds bounds,
    required String languageTag,
  }) {
    final completer = Completer<ApiResult<List<SpringMarkerEntity>>>();
    requests[languageTag] = completer;
    return completer.future;
  }

  @override
  Future<ApiResult<List<SpringSearchResult>>> searchByName({
    required String query,
    required String languageTag,
    LatLng? origin,
    int limit = 5,
  }) async => const ApiResult.success([]);
}

ProviderContainer containerWith(
  FakeSpringRepository repository, {
  SpringMarkerRepository? repositoryOverride,
}) {
  final container = ProviderContainer(
    overrides: [
      springRepositoryProvider.overrideWithValue(repository),
      if (repositoryOverride != null)
        testSpringMarkerRepositoryProvider.overrideWithValue(
          repositoryOverride,
        ),
    ],
  );
  addTearDown(container.dispose);
  container.listen(testMapMarkerProvider, (_, _) {}, fireImmediately: true);
  return container;
}
