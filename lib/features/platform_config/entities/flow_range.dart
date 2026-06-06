import 'package:freezed_annotation/freezed_annotation.dart';

part 'flow_range.freezed.dart';

/// App-side representation of a single l/s → 1–5 scale band (spec §5.3).
@freezed
abstract class FlowRange with _$FlowRange {
  const factory FlowRange({
    required int scale,
    required double minLps,
    required double maxLps,
  }) = _FlowRange;

  const FlowRange._();

  /// Whether [lps] falls within this band — inclusive on both ends, matching
  /// the server's `pickFlowScale` (api-reference.md §4.3).
  bool contains(double lps) => lps >= minLps && lps <= maxLps;
}
