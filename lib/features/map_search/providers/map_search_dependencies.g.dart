// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_search_dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Isolated client for Mapy.com; the backend bearer token is never attached.

@ProviderFor(mapSuggestDio)
final mapSuggestDioProvider = MapSuggestDioProvider._();

/// Isolated client for Mapy.com; the backend bearer token is never attached.

final class MapSuggestDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Isolated client for Mapy.com; the backend bearer token is never attached.
  MapSuggestDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapSuggestDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapSuggestDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return mapSuggestDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$mapSuggestDioHash() => r'522721780635288dcfb8822ef5075a24db624e5e';

@ProviderFor(mapSuggestApi)
final mapSuggestApiProvider = MapSuggestApiProvider._();

final class MapSuggestApiProvider
    extends $FunctionalProvider<MapSuggestApi, MapSuggestApi, MapSuggestApi>
    with $Provider<MapSuggestApi> {
  MapSuggestApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapSuggestApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapSuggestApiHash();

  @$internal
  @override
  $ProviderElement<MapSuggestApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapSuggestApi create(Ref ref) {
    return mapSuggestApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapSuggestApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapSuggestApi>(value),
    );
  }
}

String _$mapSuggestApiHash() => r'642c31670c276c2fccab321a4fd8031ce082f76c';

/// Locale-scoped data repository used by the presentation controller.

@ProviderFor(mapSearchRepository)
final mapSearchRepositoryProvider = MapSearchRepositoryFamily._();

/// Locale-scoped data repository used by the presentation controller.

final class MapSearchRepositoryProvider
    extends
        $FunctionalProvider<
          MapSearchRepository,
          MapSearchRepository,
          MapSearchRepository
        >
    with $Provider<MapSearchRepository> {
  /// Locale-scoped data repository used by the presentation controller.
  MapSearchRepositoryProvider._({
    required MapSearchRepositoryFamily super.from,
    required Locale super.argument,
  }) : super(
         retry: null,
         name: r'mapSearchRepositoryProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mapSearchRepositoryHash();

  @override
  String toString() {
    return r'mapSearchRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<MapSearchRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MapSearchRepository create(Ref ref) {
    final argument = this.argument as Locale;
    return mapSearchRepository(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapSearchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapSearchRepository>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MapSearchRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mapSearchRepositoryHash() =>
    r'7f70a0780fecc5c0dafdfca2cee5e07f7b852db3';

/// Locale-scoped data repository used by the presentation controller.

final class MapSearchRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<MapSearchRepository, Locale> {
  MapSearchRepositoryFamily._()
    : super(
        retry: null,
        name: r'mapSearchRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Locale-scoped data repository used by the presentation controller.

  MapSearchRepositoryProvider call(Locale locale) =>
      MapSearchRepositoryProvider._(argument: locale, from: this);

  @override
  String toString() => r'mapSearchRepositoryProvider';
}
