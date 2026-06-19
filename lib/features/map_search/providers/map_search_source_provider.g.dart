// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_search_source_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dedicated Dio for the third-party Mapy.com API.
///
/// Intentionally separate from the Strapi client so the backend bearer token
/// is never attached to cross-origin requests.

@ProviderFor(mapSuggestDio)
final mapSuggestDioProvider = MapSuggestDioProvider._();

/// Dedicated Dio for the third-party Mapy.com API.
///
/// Intentionally separate from the Strapi client so the backend bearer token
/// is never attached to cross-origin requests.

final class MapSuggestDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Dedicated Dio for the third-party Mapy.com API.
  ///
  /// Intentionally separate from the Strapi client so the backend bearer token
  /// is never attached to cross-origin requests.
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

String _$mapSuggestDioHash() => r'b106a86ae24fadbf3934042e8a9243edd068ce79';

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

/// Provides the active search backend. Requires the Mapy.com suggest API.

@ProviderFor(mapSearchSource)
final mapSearchSourceProvider = MapSearchSourceFamily._();

/// Provides the active search backend. Requires the Mapy.com suggest API.

final class MapSearchSourceProvider
    extends
        $FunctionalProvider<MapSearchSource, MapSearchSource, MapSearchSource>
    with $Provider<MapSearchSource> {
  /// Provides the active search backend. Requires the Mapy.com suggest API.
  MapSearchSourceProvider._({
    required MapSearchSourceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'mapSearchSourceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mapSearchSourceHash();

  @override
  String toString() {
    return r'mapSearchSourceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<MapSearchSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapSearchSource create(Ref ref) {
    final argument = this.argument as String;
    return mapSearchSource(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapSearchSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapSearchSource>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MapSearchSourceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mapSearchSourceHash() => r'1c62b26e060cbaee1f0b62152b1426f5c2dcb0b2';

/// Provides the active search backend. Requires the Mapy.com suggest API.

final class MapSearchSourceFamily extends $Family
    with $FunctionalFamilyOverride<MapSearchSource, String> {
  MapSearchSourceFamily._()
    : super(
        retry: null,
        name: r'mapSearchSourceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides the active search backend. Requires the Mapy.com suggest API.

  MapSearchSourceProvider call(String languageCode) =>
      MapSearchSourceProvider._(argument: languageCode, from: this);

  @override
  String toString() => r'mapSearchSourceProvider';
}
