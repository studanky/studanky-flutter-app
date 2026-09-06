import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/platform_config.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/report.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/spring_detail.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/water_clarity.dart';
import 'package:studanky_flutter_app/features/spring_detail/providers/spring_reports_provider.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';

/// Immutable presentation snapshot consumed by the spring detail view.
class SpringDetailViewState {
  const SpringDetailViewState({
    required this.detailAsync,
    required this.reports,
    required this.config,
    required this.marker,
    required this.isFavorite,
  });

  final AsyncValue<SpringDetail> detailAsync;
  final SpringReportsState reports;
  final PlatformConfig config;
  final SpringMarkerEntity? marker;
  final bool isFavorite;

  SpringDetail? get detail => detailAsync.value;
  String? get name => detail?.name ?? marker?.name;
  LatLng? get position => detail?.position ?? marker?.position;
  SpringStatus? get status => detail?.status ?? marker?.status;
  DateTime? get statusUpdatedAt =>
      detail?.statusUpdatedAt ?? marker?.statusUpdatedAt;
  Report? get latestReport => reports.reports.firstOrNull;
  WaterClarity? get clarity => latestReport?.waterClarity;
  int? get flowScale => detail?.lastFlowScale ?? latestReport?.flowScale;
  double? get flowRateLps =>
      detail?.lastFlowRateLps ?? latestReport?.flowRateLps;
  int get maxFlowScale => config.maxFlowScale;
  bool get canRender => name != null && position != null && status != null;

  SpringIcon? get statusIcon {
    final value = status;
    if (value == null) return null;
    return config.iconFor(value.wireValue, statusUpdatedAt);
  }

  SpringMarkerEntity? favoriteCandidate(String documentId) {
    final resolvedName = name;
    final resolvedPosition = position;
    final resolvedStatus = status;
    if (resolvedName == null ||
        resolvedPosition == null ||
        resolvedStatus == null) {
      return null;
    }
    return SpringMarkerEntity(
      documentId: documentId,
      name: resolvedName,
      position: resolvedPosition,
      status: resolvedStatus,
      statusUpdatedAt: statusUpdatedAt,
    );
  }
}
