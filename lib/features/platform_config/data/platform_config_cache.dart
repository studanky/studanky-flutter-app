import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studanky_flutter_app/features/platform_config/dtos/platform_config_dto.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/platform_config.dart';
import 'package:studanky_flutter_app/features/platform_config/mappers/platform_config_mapper.dart';

/// Local persistence for the platform config so the freshness/flow-scale logic
/// stays correct offline and across cold starts (spec §7.2 / §14).
///
/// Stores the config in its exact API shape ([PlatformConfigDto]) so the cached
/// payload round-trips through the same serialization as the network response.
class PlatformConfigCache {
  PlatformConfigCache(this._prefs);

  final SharedPreferences _prefs;
  final _logger = Logger('PlatformConfigCache');

  static const String _key = 'platform_config';

  /// Returns the cached config, or null when nothing is stored or the stored
  /// payload is unreadable (e.g. an older, incompatible schema).
  PlatformConfig? read() {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;

    try {
      final dto = PlatformConfigDto.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      return PlatformConfigMapper.fromDto(dto);
    } catch (error, stackTrace) {
      _logger.warning('Discarding unreadable cached config', error, stackTrace);
      return null;
    }
  }

  Future<void> write(PlatformConfig config) async {
    final dto = PlatformConfigMapper.toDto(config);
    await _prefs.setString(_key, jsonEncode(dto.toJson()));
  }
}
