import 'package:studanky_flutter_app/features/platform_config/dtos/flow_range_dto.dart';
import 'package:studanky_flutter_app/features/platform_config/dtos/platform_config_dto.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/flow_range.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/platform_config.dart';

/// Translates between the wire [PlatformConfigDto] and the app-side
/// [PlatformConfig] entity. Bidirectional so the local cache can round-trip the
/// entity through the exact API shape (see platform_config_cache.dart).
class PlatformConfigMapper {
  const PlatformConfigMapper._();

  static PlatformConfig fromDto(PlatformConfigDto dto) {
    return PlatformConfig(
      freshnessThreshold: Duration(days: dto.freshnessThresholdDays),
      flowScaleRanges: dto.flowScaleRanges
          .map(_flowRangeFromDto)
          .toList(growable: false),
    );
  }

  static PlatformConfigDto toDto(PlatformConfig entity) {
    return PlatformConfigDto(
      freshnessThresholdDays: entity.freshnessThreshold.inDays,
      flowScaleRanges: entity.flowScaleRanges
          .map(_flowRangeToDto)
          .toList(growable: false),
    );
  }

  static FlowRange _flowRangeFromDto(FlowRangeDto dto) =>
      FlowRange(scale: dto.scale, minLps: dto.minLps, maxLps: dto.maxLps);

  static FlowRangeDto _flowRangeToDto(FlowRange entity) => FlowRangeDto(
    scale: entity.scale,
    minLps: entity.minLps,
    maxLps: entity.maxLps,
  );
}
