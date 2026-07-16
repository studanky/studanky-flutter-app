import 'dart:async';

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
  late ProviderSubscription<MapSearchState> keepAlive;

  setUp(() {
    source = _ControllableSource();
    container = ProviderContainer(
      overrides: [
        mapSearchSourceProvider('cs').overrideWith((ref) => source),
      ],
    );
    // Hold a listener so the autoDispose notifier survives the test.
    keepAlive = container.listen(mapSearchProvider('cs'), (_, _) {});
  });

  tearDown(() {
    keepAlive.close();
    container.dispose();
  });

  test('a selection is not overwritten when a stale request completes', () async {
    final notifier = container.read(mapSearchProvider('cs').notifier)
      ..setQuery('ostr');

    await pumpPastDebounce();
    expect(source.completers, hasLength(1));

    notifier.select(_result('Ostrava'));
    expect(container.read(mapSearchProvider('cs')).query, 'Ostrava');
    expect(source.lastCancelToken?.isCancelled, isTrue);

    // The superseded request finishes late — it must not resurface.
    source.completers.first.complete([_result('stale')]);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(mapSearchProvider('cs'));
    expect(state.query, 'Ostrava');
    expect(state.searchResults.value, isEmpty);
  });

  test('clear cancels the in-flight request and drops its completion', () async {
    final notifier = container.read(mapSearchProvider('cs').notifier)
      ..setQuery('ostr');

    await pumpPastDebounce();

    notifier.clear();
    expect(source.lastCancelToken?.isCancelled, isTrue);

    source.completers.first.complete([_result('stale')]);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(mapSearchProvider('cs'));
    expect(state.query, isEmpty);
    expect(state.searchResults.value, isEmpty);
  });

  test('a backspace to a sub-threshold query cancels the running request', () async {
    final notifier = container.read(mapSearchProvider('cs').notifier)
      ..setQuery('ostr');

    await pumpPastDebounce();
    final firstToken = source.lastCancelToken;

    // Down to a single character: no new request fires, but the old one must
    // still be cancelled instead of running to completion.
    notifier.setQuery('o');
    expect(firstToken?.isCancelled, isTrue);
  });

  test('a request completing after dispose neither writes state nor throws', () async {
    container.read(mapSearchProvider('cs').notifier).setQuery('ostr');
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
  });
}
