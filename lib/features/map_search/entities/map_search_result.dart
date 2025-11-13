import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'map_search_result.freezed.dart';

@freezed
abstract class MapSearchResult with _$MapSearchResult {
  const factory MapSearchResult({
    required String label,
    required LatLng position,
    String? description,
  }) = _MapSearchResult;
}
