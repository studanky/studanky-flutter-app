import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result_type.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

part 'map_search_result.freezed.dart';

@freezed
abstract class MapSearchResult with _$MapSearchResult {
  const factory MapSearchResult({
    required String label,
    required LatLng position,
    required MapSearchResultType type,

    /// Parent location (region / municipality) shown under the [label] to
    /// disambiguate identically named places; null when the API omits it.
    String? subtitle,

    /// Geographic extent of the locality, when known. Used to fit the whole
    /// place in view; null falls back to centring on [position].
    MapSearchBounds? bounds,

    /// Present for first-party spring matches. Lets the map open the spring
    /// detail directly after moving the camera.
    SpringMarkerEntity? spring,
  }) = _MapSearchResult;
}

/// South-west / north-east corners of a locality's bounding box.
@freezed
abstract class MapSearchBounds with _$MapSearchBounds {
  const factory MapSearchBounds({
    required LatLng southWest,
    required LatLng northEast,
  }) = _MapSearchBounds;

  const MapSearchBounds._();

  /// True when the box has no area (a single point), so it can't be fitted.
  bool get isPoint =>
      southWest.latitude == northEast.latitude &&
      southWest.longitude == northEast.longitude;
}
