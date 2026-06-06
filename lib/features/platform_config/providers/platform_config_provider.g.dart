// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(platformConfigCache)
final platformConfigCacheProvider = PlatformConfigCacheProvider._();

final class PlatformConfigCacheProvider
    extends
        $FunctionalProvider<
          PlatformConfigCache,
          PlatformConfigCache,
          PlatformConfigCache
        >
    with $Provider<PlatformConfigCache> {
  PlatformConfigCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'platformConfigCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$platformConfigCacheHash();

  @$internal
  @override
  $ProviderElement<PlatformConfigCache> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlatformConfigCache create(Ref ref) {
    return platformConfigCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlatformConfigCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlatformConfigCache>(value),
    );
  }
}

String _$platformConfigCacheHash() =>
    r'ab2144de57358f37f55c19c3956c0e3b49e0c79e';

/// App-wide platform configuration, initialised right after startup.
///
/// Non-blocking by design (spec §14): [build] returns the cached config (or the
/// safe [PlatformConfig.fallback]) **synchronously**, so the freshness and
/// flow-scale logic is usable immediately and offline. A network [refresh] runs
/// in the background and swaps in fresh values when they arrive; failures keep
/// the last known config rather than surfacing an error. Refresh also fires
/// whenever the app returns to the foreground (api-reference.md §6).

@ProviderFor(PlatformConfigController)
final platformConfigControllerProvider = PlatformConfigControllerProvider._();

/// App-wide platform configuration, initialised right after startup.
///
/// Non-blocking by design (spec §14): [build] returns the cached config (or the
/// safe [PlatformConfig.fallback]) **synchronously**, so the freshness and
/// flow-scale logic is usable immediately and offline. A network [refresh] runs
/// in the background and swaps in fresh values when they arrive; failures keep
/// the last known config rather than surfacing an error. Refresh also fires
/// whenever the app returns to the foreground (api-reference.md §6).
final class PlatformConfigControllerProvider
    extends $NotifierProvider<PlatformConfigController, PlatformConfig> {
  /// App-wide platform configuration, initialised right after startup.
  ///
  /// Non-blocking by design (spec §14): [build] returns the cached config (or the
  /// safe [PlatformConfig.fallback]) **synchronously**, so the freshness and
  /// flow-scale logic is usable immediately and offline. A network [refresh] runs
  /// in the background and swaps in fresh values when they arrive; failures keep
  /// the last known config rather than surfacing an error. Refresh also fires
  /// whenever the app returns to the foreground (api-reference.md §6).
  PlatformConfigControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'platformConfigControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$platformConfigControllerHash();

  @$internal
  @override
  PlatformConfigController create() => PlatformConfigController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlatformConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlatformConfig>(value),
    );
  }
}

String _$platformConfigControllerHash() =>
    r'e42b39d7572f36e53e4e918edad3f732ecdb3b09';

/// App-wide platform configuration, initialised right after startup.
///
/// Non-blocking by design (spec §14): [build] returns the cached config (or the
/// safe [PlatformConfig.fallback]) **synchronously**, so the freshness and
/// flow-scale logic is usable immediately and offline. A network [refresh] runs
/// in the background and swaps in fresh values when they arrive; failures keep
/// the last known config rather than surfacing an error. Refresh also fires
/// whenever the app returns to the foreground (api-reference.md §6).

abstract class _$PlatformConfigController extends $Notifier<PlatformConfig> {
  PlatformConfig build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlatformConfig, PlatformConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlatformConfig, PlatformConfig>,
              PlatformConfig,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
