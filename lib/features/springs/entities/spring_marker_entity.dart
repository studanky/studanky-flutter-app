import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';

part 'spring_marker_entity.freezed.dart';

/// App-side representation of a single spring as shown on the map.
///
/// Carries everything the marker needs — including the raw [status] and
/// [statusUpdatedAt] — so the three-state icon can be computed reactively
/// against `platform_config` and the current time, rather than being frozen at
/// fetch time.
@freezed
abstract class SpringMarkerEntity with _$SpringMarkerEntity {
  const factory SpringMarkerEntity({
    required String documentId,
    required String name,
    required LatLng position,
    required SpringStatus status,
    DateTime? statusUpdatedAt,
  }) = _SpringMarkerEntity;
}
