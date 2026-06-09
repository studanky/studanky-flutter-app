// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the list of favourited springs (newest first) and keeps it persisted.
///
/// Reads are synchronous (SharedPreferences is resolved at startup), so the
/// state is available immediately for the map button, the popup and the detail
/// toggle.

@ProviderFor(FavoritesController)
final favoritesControllerProvider = FavoritesControllerProvider._();

/// Owns the list of favourited springs (newest first) and keeps it persisted.
///
/// Reads are synchronous (SharedPreferences is resolved at startup), so the
/// state is available immediately for the map button, the popup and the detail
/// toggle.
final class FavoritesControllerProvider
    extends $NotifierProvider<FavoritesController, List<SpringMarkerEntity>> {
  /// Owns the list of favourited springs (newest first) and keeps it persisted.
  ///
  /// Reads are synchronous (SharedPreferences is resolved at startup), so the
  /// state is available immediately for the map button, the popup and the detail
  /// toggle.
  FavoritesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesControllerHash();

  @$internal
  @override
  FavoritesController create() => FavoritesController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SpringMarkerEntity> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SpringMarkerEntity>>(value),
    );
  }
}

String _$favoritesControllerHash() =>
    r'87ff843ebba7885ca08df0b9020fde0c42ab7326';

/// Owns the list of favourited springs (newest first) and keeps it persisted.
///
/// Reads are synchronous (SharedPreferences is resolved at startup), so the
/// state is available immediately for the map button, the popup and the detail
/// toggle.

abstract class _$FavoritesController
    extends $Notifier<List<SpringMarkerEntity>> {
  List<SpringMarkerEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<SpringMarkerEntity>, List<SpringMarkerEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SpringMarkerEntity>, List<SpringMarkerEntity>>,
              List<SpringMarkerEntity>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
