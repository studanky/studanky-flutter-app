// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spring_detail_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(springDetailRepository)
final springDetailRepositoryProvider = SpringDetailRepositoryProvider._();

final class SpringDetailRepositoryProvider
    extends
        $FunctionalProvider<
          SpringDetailRepository,
          SpringDetailRepository,
          SpringDetailRepository
        >
    with $Provider<SpringDetailRepository> {
  SpringDetailRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'springDetailRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$springDetailRepositoryHash();

  @$internal
  @override
  $ProviderElement<SpringDetailRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SpringDetailRepository create(Ref ref) {
    return springDetailRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpringDetailRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpringDetailRepository>(value),
    );
  }
}

String _$springDetailRepositoryHash() =>
    r'6f36f2d18073ce7eaf23fb82a43a8b9e33e0ca10';
