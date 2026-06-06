// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_feature_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(exampleFeatureRepository)
final exampleFeatureRepositoryProvider = ExampleFeatureRepositoryProvider._();

final class ExampleFeatureRepositoryProvider
    extends
        $FunctionalProvider<
          ExampleFeatureRepository,
          ExampleFeatureRepository,
          ExampleFeatureRepository
        >
    with $Provider<ExampleFeatureRepository> {
  ExampleFeatureRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exampleFeatureRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exampleFeatureRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExampleFeatureRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExampleFeatureRepository create(Ref ref) {
    return exampleFeatureRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExampleFeatureRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExampleFeatureRepository>(value),
    );
  }
}

String _$exampleFeatureRepositoryHash() =>
    r'c9603d41140a18c8517ef0948d1faa0ee43fb14d';
