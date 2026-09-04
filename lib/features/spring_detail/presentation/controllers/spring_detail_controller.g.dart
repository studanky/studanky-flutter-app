// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spring_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composes detail, reports, favourites and platform config into one UI state
/// and exposes the commands available from the detail screen.

@ProviderFor(SpringDetailController)
final springDetailControllerProvider = SpringDetailControllerFamily._();

/// Composes detail, reports, favourites and platform config into one UI state
/// and exposes the commands available from the detail screen.
final class SpringDetailControllerProvider
    extends $NotifierProvider<SpringDetailController, SpringDetailViewState> {
  /// Composes detail, reports, favourites and platform config into one UI state
  /// and exposes the commands available from the detail screen.
  SpringDetailControllerProvider._({
    required SpringDetailControllerFamily super.from,
    required (String, {String languageTag, SpringMarkerEntity? marker})
    super.argument,
  }) : super(
         retry: null,
         name: r'springDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$springDetailControllerHash();

  @override
  String toString() {
    return r'springDetailControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SpringDetailController create() => SpringDetailController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpringDetailViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpringDetailViewState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SpringDetailControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$springDetailControllerHash() =>
    r'1394cbc9dd0b1e1370de2518e352d0e008fb0635';

/// Composes detail, reports, favourites and platform config into one UI state
/// and exposes the commands available from the detail screen.

final class SpringDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          SpringDetailController,
          SpringDetailViewState,
          SpringDetailViewState,
          SpringDetailViewState,
          (String, {String languageTag, SpringMarkerEntity? marker})
        > {
  SpringDetailControllerFamily._()
    : super(
        retry: null,
        name: r'springDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Composes detail, reports, favourites and platform config into one UI state
  /// and exposes the commands available from the detail screen.

  SpringDetailControllerProvider call(
    String documentId, {
    required String languageTag,
    SpringMarkerEntity? marker,
  }) => SpringDetailControllerProvider._(
    argument: (documentId, languageTag: languageTag, marker: marker),
    from: this,
  );

  @override
  String toString() => r'springDetailControllerProvider';
}

/// Composes detail, reports, favourites and platform config into one UI state
/// and exposes the commands available from the detail screen.

abstract class _$SpringDetailController
    extends $Notifier<SpringDetailViewState> {
  late final _$args =
      ref.$arg as (String, {String languageTag, SpringMarkerEntity? marker});
  String get documentId => _$args.$1;
  String get languageTag => _$args.languageTag;
  SpringMarkerEntity? get marker => _$args.marker;

  SpringDetailViewState build(
    String documentId, {
    required String languageTag,
    SpringMarkerEntity? marker,
  });
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SpringDetailViewState, SpringDetailViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SpringDetailViewState, SpringDetailViewState>,
              SpringDetailViewState,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(
        _$args.$1,
        languageTag: _$args.languageTag,
        marker: _$args.marker,
      ),
    );
  }
}
