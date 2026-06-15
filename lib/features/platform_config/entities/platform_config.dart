import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/flow_range.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';

part 'platform_config.freezed.dart';

/// Dynamic, server-driven configuration the client downloads, caches, and uses
/// to compute state itself (spec §7.2, api-reference.md §3.4).
///
/// The two derived helpers ([iconFor], [flowScaleFromLps]) embody the
/// client-side logic from api-reference.md §4 so callers never re-implement the
/// freshness or flow-scale rules.
@freezed
abstract class PlatformConfig with _$PlatformConfig {
  const factory PlatformConfig({
    /// Age after which a status is considered "stale" (spec default 14 days).
    required Duration freshnessThreshold,

    /// l/s → 1–5 mapping table. Empty until the ranges component is populated.
    required List<FlowRange> flowScaleRanges,
  }) = _PlatformConfig;

  const PlatformConfig._();

  /// Safe defaults used before the network responds and when nothing is cached
  /// (spec §14: always show last known / sane data). Matches the documented
  /// default threshold; ranges stay empty so [flowScaleFromLps] returns null
  /// rather than guessing values that must come from the server.
  static const fallback = PlatformConfig(
    freshnessThreshold: Duration(days: 14),
    flowScaleRanges: <FlowRange>[],
  );

  /// API `current_status` values (not localized) — kept as constants so the
  /// string contract lives in one place.
  static const String statusFlowing = 'is_flowing';
  static const String statusNotFlowing = 'is_not_flowing';
  static const String statusUnknown = 'unknown';

  /// Computes the three-state map icon from the latest report (spec §4.1).
  ///
  /// "stale" overrides flowing/not-flowing once [statusUpdatedAt] is older than
  /// [freshnessThreshold]. Evaluated against the device's current time so the
  /// result is always accurate, independent of when data was fetched. Pass
  /// [now] only to make tests deterministic.
  SpringIcon iconFor(
    String? currentStatus,
    DateTime? statusUpdatedAt, {
    DateTime? now,
  }) {
    if (statusUpdatedAt == null || currentStatus == statusUnknown) {
      return SpringIcon.unknown;
    }

    final age = (now ?? DateTime.now()).toUtc().difference(
      statusUpdatedAt.toUtc(),
    );
    if (age > freshnessThreshold) {
      return SpringIcon.stale; // overrides the flow state
    }

    return currentStatus == statusFlowing
        ? SpringIcon.flowing
        : SpringIcon.notFlowing;
  }

  /// Converts a measured discharge to the shared 1–5 scale using the live
  /// ranges (spec §5.3 / api-reference.md §4.3). Returns null when [lps] is null
  /// or falls outside every configured band.
  int? flowScaleFromLps(double? lps) {
    if (lps == null) return null;
    for (final range in flowScaleRanges) {
      if (range.contains(lps)) return range.scale;
    }
    return null;
  }

  /// Top of the flow-strength scale ("n" in the 1…n readout). Derived from the
  /// live ranges so the graphical scale tracks the server config; falls back to
  /// the documented default of 5 before the ranges are populated.
  int get maxFlowScale => flowScaleRanges.isEmpty
      ? 5
      : flowScaleRanges.map((r) => r.scale).reduce(math.max);
}
