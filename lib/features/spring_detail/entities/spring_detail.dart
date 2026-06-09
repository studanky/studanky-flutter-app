import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/spring_owner.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/spring_photo.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';

part 'spring_detail.freezed.dart';

/// Full spring detail shown in the bottom sheet header (api-reference.md §3.2).
///
/// Keeps the raw status and its timestamp so freshness (the three-state icon
/// and "stale" override) is computed reactively against `platform_config`,
/// exactly like the map marker.
@freezed
abstract class SpringDetail with _$SpringDetail {
  const factory SpringDetail({
    required String documentId,
    required String name,
    required LatLng position,
    required SpringStatus status,
    String? description,
    DateTime? statusUpdatedAt,
    int? lastFlowScale,
    double? lastFlowRateLps,
    SpringPhoto? photo,
    SpringOwner? owner,
  }) = _SpringDetail;
}
