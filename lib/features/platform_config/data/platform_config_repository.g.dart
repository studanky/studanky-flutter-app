// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_config_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(platformConfigRepository)
final platformConfigRepositoryProvider = PlatformConfigRepositoryProvider._();

final class PlatformConfigRepositoryProvider
    extends
        $FunctionalProvider<
          PlatformConfigRepository,
          PlatformConfigRepository,
          PlatformConfigRepository
        >
    with $Provider<PlatformConfigRepository> {
  PlatformConfigRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'platformConfigRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$platformConfigRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlatformConfigRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlatformConfigRepository create(Ref ref) {
    return platformConfigRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlatformConfigRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlatformConfigRepository>(value),
    );
  }
}

String _$platformConfigRepositoryHash() =>
    r'3a4c86e3d1f12dfac2c060c15bf29248ad871f1b';
