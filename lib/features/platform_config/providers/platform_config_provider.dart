import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/core/providers/shared_preferences_provider.dart';
import 'package:studanky_flutter_app/features/platform_config/data/platform_config_cache.dart';
import 'package:studanky_flutter_app/features/platform_config/data/platform_config_repository.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/platform_config.dart';

part 'platform_config_provider.g.dart';

@Riverpod(keepAlive: true)
PlatformConfigCache platformConfigCache(Ref ref) =>
    PlatformConfigCache(ref.watch(sharedPreferencesProvider));

/// App-wide platform configuration, initialised right after startup.
///
/// Non-blocking by design (spec §14): [build] returns the cached config (or the
/// safe [PlatformConfig.fallback]) **synchronously**, so the freshness and
/// flow-scale logic is usable immediately and offline. A network [refresh] runs
/// in the background and swaps in fresh values when they arrive; failures keep
/// the last known config rather than surfacing an error. Refresh also fires
/// whenever the app returns to the foreground (api-reference.md §6).
@Riverpod(keepAlive: true)
class PlatformConfigController extends _$PlatformConfigController {
  final _logger = Logger('PlatformConfigController');
  bool _isRefreshing = false;

  @override
  PlatformConfig build() {
    // Refresh on resume (launch + foreground). Disposed with the provider.
    final lifecycle = AppLifecycleListener(
      onResume: () => unawaited(refresh()),
    );
    ref.onDispose(lifecycle.dispose);

    // Kick off the initial network refresh without blocking the first frame.
    Future.microtask(refresh);

    return ref.read(platformConfigCacheProvider).read() ??
        PlatformConfig.fallback;
  }

  /// Fetches the live config and, on success, persists it and updates state.
  /// On failure the current (cached/fallback) config is kept.
  Future<void> refresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    try {
      final result = await ref.read(platformConfigRepositoryProvider).fetch();
      switch (result) {
        case Success(:final data):
          await ref.read(platformConfigCacheProvider).write(data);
          state = data;
          _logger.fine('Platform config refreshed');
        case Failure(:final exception):
          _logger.warning(
            'Platform config refresh failed; keeping last known config',
            exception,
          );
      }
    } finally {
      _isRefreshing = false;
    }
  }
}
