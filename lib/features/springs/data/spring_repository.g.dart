// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spring_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(springRepository)
final springRepositoryProvider = SpringRepositoryProvider._();

final class SpringRepositoryProvider
    extends
        $FunctionalProvider<
          SpringRepository,
          SpringRepository,
          SpringRepository
        >
    with $Provider<SpringRepository> {
  SpringRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'springRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$springRepositoryHash();

  @$internal
  @override
  $ProviderElement<SpringRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SpringRepository create(Ref ref) {
    return springRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpringRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpringRepository>(value),
    );
  }
}

String _$springRepositoryHash() => r'18ad3c7e522b6b474cd11eeb77ff3ba6ce7b9353';
