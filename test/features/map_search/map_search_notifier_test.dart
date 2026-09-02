import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result_type.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_provider.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_source_provider.dart';

MapSearchResult _result(String label) => MapSearchResult(
  label: label,
  position: const LatLng(50, 14),
  type: MapSearchResultType.other,
);

const _csLocale = Locale('cs');
const _enAuLocale = Locale('en', 'AU');

/// A source whose requests never resolve on their own, so a test can hold one
/// "in flight" and decide exactly when (and whether) it completes.
class _ControllableSource implements MapSearchSource {
  final List<Completer<List<MapSearchResult>>> completers = [];
  CancelToken? lastCancelToken;

  @override
  Future<List<MapSearchResult>> search(
    String query, {
    LatLng? origin,
    CancelToken? cancelToken,
  }) {
    lastCancelToken = cancelToken;
    final completer = Completer<List<MapSearchResult>>();
    completers.add(completer);
    return completer.future;
  }
}

void main() {
  // Debounce is 300ms; wait past it so the scheduled request actually fires.
  Future<void> pumpPastDebounce() =>
      Future<void>.delayed(const Duration(milliseconds: 350));

  late ProviderContainer container;
  late _ControllableSource source;
  late _ControllableSource englishSource;
  late ProviderSubscription<MapSearchState> keepAlive;

  setUp(() {
    source = _ControllableSource();
    englishSource = _ControllableSource();
    container = ProviderContainer(
      overrides: [
        mapSearchSourceProvider(_csLocale).overrideWithValue(source),
        mapSearchSourceProvider(_enAuLocale).overrideWithValue(englishSource),
      ],
    );
    // Hold a listener so the autoDispose notifier survives the test.
    keepAlive = container.listen(mapSearchProvider, (_, _) {});
  });

  tearDown(() {
    keepAlive.close();
    container.dispose();
  });

  test(
    'a selection is not overwritten when a stale request completes',
    () async {
      final notifier = container.read(mapSearchProvider.notifier)
        ..setQuery('ostr', locale: _csLocale);

      await pumpPastDebounce();
      expect(source.completers, hasLength(1));

      notifier.select(_result('Ostrava'));
      expect(container.read(mapSearchProvider).query, 'Ostrava');
      expect(source.lastCancelToken?.isCancelled, isTrue);

      // The superseded request finishes late — it must not resurface.
      source.completers.first.complete([_result('stale')]);
      await Future<void>.delayed(Duration.zero);

      final state = container.read(mapSearchProvider);
      expect(state.query, 'Ostrava');
      expect(state.searchResults.value, isEmpty);
    },
  );

  test(
    'clear cancels the in-flight request and drops its completion',
    () async {
      final notifier = container.read(mapSearchProvider.notifier)
        ..setQuery('ostr', locale: _csLocale);

      await pumpPastDebounce();

      notifier.clear();
      expect(source.lastCancelToken?.isCancelled, isTrue);

      source.completers.first.complete([_result('stale')]);
      await Future<void>.delayed(Duration.zero);

      final state = container.read(mapSearchProvider);
      expect(state.query, isEmpty);
      expect(state.searchResults.value, isEmpty);
    },
  );

  test(
    'a backspace to a sub-threshold query cancels the running request',
    () async {
      final notifier = container.read(mapSearchProvider.notifier)
        ..setQuery('ostr', locale: _csLocale);

      await pumpPastDebounce();
      final firstToken = source.lastCancelToken;

      // Down to a single character: no new request fires, but the old one must
      // still be cancelled instead of running to completion.
      notifier.setQuery('o', locale: _csLocale);
      expect(firstToken?.isCancelled, isTrue);
    },
  );

  test(
    'a request completing after dispose neither writes state nor throws',
    () async {
      container
          .read(mapSearchProvider.notifier)
          .setQuery('ostr', locale: _csLocale);
      await pumpPastDebounce();
      expect(source.completers, hasLength(1));

      // Drop the only listener so the autoDispose notifier disposes.
      keepAlive.close();
      await Future<void>.delayed(Duration.zero);

      // A Spring-like request that ignored the cancel token finishes late. The
      // dispose-time token bump must make this a no-op: no write to the disposed
      // notifier and no uncaught async error (either would fail this test).
      source.completers.first.complete([_result('late')]);
      await Future<void>.delayed(Duration.zero);

      expect(source.completers.first.isCompleted, isTrue);
    },
  );

  test('a locale change preserves and repeats the active query', () async {
    final notifier = container.read(mapSearchProvider.notifier)
      ..setQuery('ostr', locale: _csLocale);
    await pumpPastDebounce();

    final czechToken = source.lastCancelToken;
    notifier.updateLocale(_enAuLocale);

    expect(container.read(mapSearchProvider).query, 'ostr');
    expect(czechToken?.isCancelled, isTrue);

    await pumpPastDebounce();
    expect(englishSource.completers, hasLength(1));

    source.completers.first.complete([_result('stale')]);
    englishSource.completers.first.complete([_result('fresh')]);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(mapSearchProvider);
    expect(state.query, 'ostr');
    expect(state.searchResults.value?.single.label, 'fresh');
  });

  test('a locale change resolves a pending one-character query', () async {
    final notifier = container.read(mapSearchProvider.notifier)
      ..setQuery('o', locale: _csLocale);

    expect(container.read(mapSearchProvider).searchResults.isLoading, isTrue);

    // Switch before the original debounce fires. The new locale must still
    // execute the source-owned short-query policy and settle to data([]).
    notifier.updateLocale(_enAuLocale);
    await pumpPastDebounce();

    expect(source.completers, isEmpty);
    expect(englishSource.completers, hasLength(1));
    englishSource.completers.single.complete(const []);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(mapSearchProvider);
    expect(state.query, 'o');
    expect(state.searchResults.isLoading, isFalse);
    expect(state.searchResults.value, isEmpty);
  });

  test('a locale change does not restart a completed selection', () async {
    final notifier = container.read(mapSearchProvider.notifier)
      ..setQuery('ostr', locale: _csLocale);
    await pumpPastDebounce();

    notifier
      ..select(_result('Ostrava'))
      ..updateLocale(_enAuLocale);
    await pumpPastDebounce();

    expect(container.read(mapSearchProvider).query, 'Ostrava');
    expect(englishSource.completers, isEmpty);

    source.completers.first.complete([_result('stale')]);
    await Future<void>.delayed(Duration.zero);
  });
}
