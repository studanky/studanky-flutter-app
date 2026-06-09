// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spring_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads the full spring detail for the header. Auto-disposed with the sheet.
///
/// The repository returns an `ApiResult`; unwrapping with `orThrow` lets the
/// surrounding `AsyncValue` capture the typed failure for the UI.

@ProviderFor(springDetail)
final springDetailProvider = SpringDetailFamily._();

/// Loads the full spring detail for the header. Auto-disposed with the sheet.
///
/// The repository returns an `ApiResult`; unwrapping with `orThrow` lets the
/// surrounding `AsyncValue` capture the typed failure for the UI.

final class SpringDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<SpringDetail>,
          SpringDetail,
          FutureOr<SpringDetail>
        >
    with $FutureModifier<SpringDetail>, $FutureProvider<SpringDetail> {
  /// Loads the full spring detail for the header. Auto-disposed with the sheet.
  ///
  /// The repository returns an `ApiResult`; unwrapping with `orThrow` lets the
  /// surrounding `AsyncValue` capture the typed failure for the UI.
  SpringDetailProvider._({
    required SpringDetailFamily super.from,
    required (String, {String? locale}) super.argument,
  }) : super(
         retry: null,
         name: r'springDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$springDetailHash();

  @override
  String toString() {
    return r'springDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<SpringDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SpringDetail> create(Ref ref) {
    final argument = this.argument as (String, {String? locale});
    return springDetail(ref, argument.$1, locale: argument.locale);
  }

  @override
  bool operator ==(Object other) {
    return other is SpringDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$springDetailHash() => r'36506daf4edc43bbb562ed088536b987c571183a';

/// Loads the full spring detail for the header. Auto-disposed with the sheet.
///
/// The repository returns an `ApiResult`; unwrapping with `orThrow` lets the
/// surrounding `AsyncValue` capture the typed failure for the UI.

final class SpringDetailFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<SpringDetail>,
          (String, {String? locale})
        > {
  SpringDetailFamily._()
    : super(
        retry: null,
        name: r'springDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Loads the full spring detail for the header. Auto-disposed with the sheet.
  ///
  /// The repository returns an `ApiResult`; unwrapping with `orThrow` lets the
  /// surrounding `AsyncValue` capture the typed failure for the UI.

  SpringDetailProvider call(String documentId, {String? locale}) =>
      SpringDetailProvider._(
        argument: (documentId, locale: locale),
        from: this,
      );

  @override
  String toString() => r'springDetailProvider';
}
