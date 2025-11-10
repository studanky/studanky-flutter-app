import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_source_provider.dart';

part 'map_search_provider.freezed.dart';

@freezed
abstract class MapSearchState with _$MapSearchState {
  const factory MapSearchState({
    @Default('') String query,
    @Default(AsyncValue.data(<MapSearchResult>[]))
    AsyncValue<List<MapSearchResult>> searchResults,
    MapSearchResult? selected,
  }) = _MapSearchState;
}

final mapSearchProvider =
    NotifierProvider.autoDispose<MapSearchNotifier, MapSearchState>(
      MapSearchNotifier.new,
    );

/// Debounced notifier that coordinates search requests and exposes results.
class MapSearchNotifier extends Notifier<MapSearchState> {
  static const Duration _kDebounceDuration = Duration(milliseconds: 250);

  Timer? _debounceTimer;
  int _lastToken = 0;

  MapSearchSource get _searchSource => ref.read(mapSearchSourceProvider);

  @override
  MapSearchState build() {
    ref.onDispose(() => _debounceTimer?.cancel());
    return const MapSearchState();
  }

  /// Sets the current query and schedules a debounced backend request.
  void setQuery(String query) {
    if (query == state.query) {
      return;
    }

    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      state = const MapSearchState();
      return;
    }

    final token = ++_lastToken;
    state = state.copyWith(
      query: query,
      searchResults: const AsyncValue<List<MapSearchResult>>.loading(),
      selected: null,
    );

    _debounceTimer = Timer(_kDebounceDuration, () {
      _performSearch(query, token);
    });
  }

  /// Clears query, results, and active timers.
  void clear() {
    _debounceTimer?.cancel();
    state = const MapSearchState();
  }

  /// Stores the selection and collapses the suggestions list.
  void select(MapSearchResult result) {
    _debounceTimer?.cancel();
    state = state.copyWith(
      query: result.label,
      searchResults: const AsyncValue<List<MapSearchResult>>.data([]),
      selected: result,
    );
  }

  Future<void> _performSearch(String query, int token) async {
    try {
      final results = await _searchSource.search(query);
      if (token != _lastToken) return;

      state = state.copyWith(
        query: query,
        searchResults: AsyncValue<List<MapSearchResult>>.data(results),
        selected: null,
      );
    } catch (error, stackTrace) {
      Logger().e(
        '[MapSearchNotifier] Search failed for "$query"',
        error: error,
        stackTrace: stackTrace,
      );
      if (token != _lastToken) return;
      state = state.copyWith(
        searchResults: AsyncValue<List<MapSearchResult>>.error(
          error,
          stackTrace,
        ),
        selected: null,
      );
    }
  }
}
