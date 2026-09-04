// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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
    r'd99d98a3c039d849bb81bd5e4691e6a54e1b7548';

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
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PlatformConfig, PlatformConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlatformConfig, PlatformConfig>,
              PlatformConfig,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
