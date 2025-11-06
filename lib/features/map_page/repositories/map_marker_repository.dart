import 'package:flutter_map/flutter_map.dart';
import 'package:studanky_flutter_app/features/map_page/data/map_marker_source.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_marker_entity.dart';

abstract class MapMarkerRepository {
  Future<List<MapMarkerEntity>> fetchMarkers(LatLngBounds bounds);
}

class MapMarkerRepositoryImpl implements MapMarkerRepository {
  MapMarkerRepositoryImpl(this._source);

  final MapMarkerSource _source;

  @override
  Future<List<MapMarkerEntity>> fetchMarkers(LatLngBounds bounds) {
    return _source.loadMarkers(bounds);
  }
}
