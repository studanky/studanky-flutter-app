import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

/// One result from `GET /api/springs/search`: a map-renderable spring plus
/// optional distance from the search origin.
class SpringSearchResult {
  const SpringSearchResult({required this.spring, this.distanceMeters});

  final SpringMarkerEntity spring;
  final int? distanceMeters;
}
