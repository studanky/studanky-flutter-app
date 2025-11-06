import 'package:flutter_map/flutter_map.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_marker_entity.dart';
import 'package:studanky_flutter_app/features/spring_getter/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/spring_getter/entities/spring_entity.dart';
import 'package:studanky_flutter_app/features/spring_getter/repositories/spring_repository.dart';

abstract class MapMarkerRepository {
  Future<List<MapMarkerEntity>> fetchMarkers(LatLngBounds bounds);

  Future<List<MapMarkerEntity>> fetchAllMarkers();
}

class MapMarkerRepositoryImpl implements MapMarkerRepository {
  MapMarkerRepositoryImpl(this._springRepository);

  final SpringRepository _springRepository;

  @override
  Future<List<MapMarkerEntity>> fetchMarkers(LatLngBounds bounds) async {
    final springs = await _springRepository.fetchSprings(
      SpringBounds(
        north: bounds.north,
        south: bounds.south,
        east: bounds.east,
        west: bounds.west,
      ),
    );
    return _convert(springs);
  }

  @override
  Future<List<MapMarkerEntity>> fetchAllMarkers() async {
    final springs = await _springRepository.fetchAllSprings();
    return _convert(springs);
  }

  List<MapMarkerEntity> _convert(List<SpringEntity> springs) {
    return springs
        .map(
          (spring) =>
              MapMarkerEntity(position: spring.position, label: spring.label),
        )
        .toList(growable: false);
  }
}
