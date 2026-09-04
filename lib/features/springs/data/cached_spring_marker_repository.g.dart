// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_spring_marker_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(springMarkerRepository)
final springMarkerRepositoryProvider = SpringMarkerRepositoryProvider._();

final class SpringMarkerRepositoryProvider
    extends
        $FunctionalProvider<
          SpringMarkerRepository,
          SpringMarkerRepository,
          SpringMarkerRepository
        >
    with $Provider<SpringMarkerRepository> {
  SpringMarkerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'springMarkerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$springMarkerRepositoryHash();

  @$internal
  @override
  $ProviderElement<SpringMarkerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SpringMarkerRepository create(Ref ref) {
    return springMarkerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpringMarkerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpringMarkerRepository>(value),
    );
  }
}

String _$springMarkerRepositoryHash() =>
    r'afa7e239159cbd709882a12587276691953c5924';
