// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spring_marker_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(springMarkerSource)
final springMarkerSourceProvider = SpringMarkerSourceProvider._();

final class SpringMarkerSourceProvider
    extends
        $FunctionalProvider<
          SpringMarkerSource,
          SpringMarkerSource,
          SpringMarkerSource
        >
    with $Provider<SpringMarkerSource> {
  SpringMarkerSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'springMarkerSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$springMarkerSourceHash();

  @$internal
  @override
  $ProviderElement<SpringMarkerSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SpringMarkerSource create(Ref ref) {
    return springMarkerSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpringMarkerSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpringMarkerSource>(value),
    );
  }
}

String _$springMarkerSourceHash() =>
    r'64b30412f8246638be413c34635bb7121a954f0f';
