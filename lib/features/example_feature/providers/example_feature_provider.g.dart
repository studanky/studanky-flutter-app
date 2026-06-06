// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_feature_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExampleFeature)
final exampleFeatureProvider = ExampleFeatureProvider._();

final class ExampleFeatureProvider
    extends $NotifierProvider<ExampleFeature, ExampleFeatureState> {
  ExampleFeatureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exampleFeatureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exampleFeatureHash();

  @$internal
  @override
  ExampleFeature create() => ExampleFeature();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExampleFeatureState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExampleFeatureState>(value),
    );
  }
}

String _$exampleFeatureHash() => r'b6837a8fa3a0ede70e28d47498755e2a52913f40';

abstract class _$ExampleFeature extends $Notifier<ExampleFeatureState> {
  ExampleFeatureState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ExampleFeatureState, ExampleFeatureState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExampleFeatureState, ExampleFeatureState>,
              ExampleFeatureState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
