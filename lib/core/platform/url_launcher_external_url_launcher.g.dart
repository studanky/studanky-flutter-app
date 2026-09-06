// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_launcher_external_url_launcher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(externalUrlLauncher)
final externalUrlLauncherProvider = ExternalUrlLauncherProvider._();

final class ExternalUrlLauncherProvider
    extends
        $FunctionalProvider<
          ExternalUrlLauncher,
          ExternalUrlLauncher,
          ExternalUrlLauncher
        >
    with $Provider<ExternalUrlLauncher> {
  ExternalUrlLauncherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'externalUrlLauncherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$externalUrlLauncherHash();

  @$internal
  @override
  $ProviderElement<ExternalUrlLauncher> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExternalUrlLauncher create(Ref ref) {
    return externalUrlLauncher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExternalUrlLauncher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExternalUrlLauncher>(value),
    );
  }
}

String _$externalUrlLauncherHash() =>
    r'0c714555e9fdde8fb7b2728ee6ff589934ed2ef4';
