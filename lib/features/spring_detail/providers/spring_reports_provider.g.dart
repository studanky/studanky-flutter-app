// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spring_reports_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives infinite scroll over `GET /springs/:id/reports` (api-reference.md
/// §3.3): page 1 loads on open, further pages are appended on [SpringReports.loadMore].

@ProviderFor(SpringReports)
final springReportsProvider = SpringReportsFamily._();

/// Drives infinite scroll over `GET /springs/:id/reports` (api-reference.md
/// §3.3): page 1 loads on open, further pages are appended on [SpringReports.loadMore].
final class SpringReportsProvider
    extends $NotifierProvider<SpringReports, SpringReportsState> {
  /// Drives infinite scroll over `GET /springs/:id/reports` (api-reference.md
  /// §3.3): page 1 loads on open, further pages are appended on [SpringReports.loadMore].
  SpringReportsProvider._({
    required SpringReportsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'springReportsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$springReportsHash();

  @override
  String toString() {
    return r'springReportsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SpringReports create() => SpringReports();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpringReportsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpringReportsState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SpringReportsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$springReportsHash() => r'afd2791273a65e03d11e157f39107a3d67c28b5f';

/// Drives infinite scroll over `GET /springs/:id/reports` (api-reference.md
/// §3.3): page 1 loads on open, further pages are appended on [SpringReports.loadMore].

final class SpringReportsFamily extends $Family
    with
        $ClassFamilyOverride<
          SpringReports,
          SpringReportsState,
          SpringReportsState,
          SpringReportsState,
          String
        > {
  SpringReportsFamily._()
    : super(
        retry: null,
        name: r'springReportsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Drives infinite scroll over `GET /springs/:id/reports` (api-reference.md
  /// §3.3): page 1 loads on open, further pages are appended on [SpringReports.loadMore].

  SpringReportsProvider call(String documentId) =>
      SpringReportsProvider._(argument: documentId, from: this);

  @override
  String toString() => r'springReportsProvider';
}

/// Drives infinite scroll over `GET /springs/:id/reports` (api-reference.md
/// §3.3): page 1 loads on open, further pages are appended on [SpringReports.loadMore].

abstract class _$SpringReports extends $Notifier<SpringReportsState> {
  late final _$args = ref.$arg as String;
  String get documentId => _$args;

  SpringReportsState build(String documentId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SpringReportsState, SpringReportsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SpringReportsState, SpringReportsState>,
              SpringReportsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
