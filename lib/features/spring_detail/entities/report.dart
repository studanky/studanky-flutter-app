import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/water_clarity.dart';

part 'report.freezed.dart';

/// One status record in a spring's history (api-reference.md §2.2 / §3.3).
@freezed
abstract class Report with _$Report {
  const factory Report({
    required String documentId,
    required bool isFlowing,
    required DateTime reportedAt,
    int? flowScale,
    double? flowRateLps,
    bool? hasOdor,
    WaterClarity? waterClarity,
    String? note,
  }) = _Report;

  const Report._();

  bool get hasNote => note != null && note!.trim().isNotEmpty;

  /// Whether the record carries any subjective community-reported detail. ČHMÚ
  /// station records only measure discharge, so this is false for them.
  bool get hasSubjectiveData =>
      hasOdor != null || waterClarity != null || hasNote;

  /// Heuristic for a ČHMÚ station measurement: a measured discharge with no
  /// subjective fields. The public report allowlist carries no `source` field
  /// (api-reference.md §3.3), so this is derived; swap it for the real field if
  /// the API later exposes provenance.
  bool get isStationMeasurement => flowRateLps != null && !hasSubjectiveData;

  /// Whether there is anything worth expanding the row to show.
  bool get hasDetails =>
      flowScale != null ||
      flowRateLps != null ||
      hasOdor != null ||
      waterClarity != null ||
      hasNote;
}
