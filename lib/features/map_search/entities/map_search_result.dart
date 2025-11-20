import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result_type.dart';

part 'map_search_result.freezed.dart';

@freezed
abstract class MapSearchResult with _$MapSearchResult {
  const factory MapSearchResult({
    required String label,
    required LatLng position,
    required MapSearchResultType type,
  }) = _MapSearchResult;
}
