import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
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
  }) = _MapSearchState;
}

final mapSearchProvider = NotifierProvider.autoDispose
    .family<MapSearchNotifier, MapSearchState, String>(MapSearchNotifier.new);

/// Debounced notifier that coordinates search requests and exposes results.
class MapSearchNotifier extends Notifier<MapSearchState> {
  MapSearchNotifier(this._languageCode);

  static const Duration _kDebounceDuration = Duration(milliseconds: 300);

  final _logger = Logger('MapSearchNotifier');

  Timer? _debounceTimer;
  int _lastToken = 0;

  /// The active backend request, cancelled whenever the query is superseded,
  /// cleared, or a result is selected — so the client stops waiting for and
  /// processing a now-outdated response. Owned here, not in the source, so it
  /// can be aborted even when no new request is issued (e.g. clear, or a
  /// backspace down to a sub-threshold query).
  CancelToken? _inFlightRequest;

  final String _languageCode;

  MapSearchSource get _searchSource =>
      ref.read(mapSearchSourceProvider(_languageCode));

  @override
  MapSearchState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
      _cancelInFlight();
      // Invalidate any late completion too: the Spring source ignores the
      // cancel token, so a composite search can still finish after dispose —
      // bumping the token makes its guard trip instead of writing to (now
      // disposed) state.
      ++_lastToken;
    });
    return const MapSearchState();
  }

  /// Cancels the running request (if any) and forgets it. Callers must also
  /// advance [_lastToken] so a request that completes mid-flight is dropped.
  void _cancelInFlight() {
    _inFlightRequest?.cancel();
    _inFlightRequest = null;
  }

  /// Sets the current query and schedules a debounced backend request.
  void setQuery(String query, {LatLng? origin}) {
    if (query == state.query) {
      return;
    }

    _debounceTimer?.cancel();
    // The query moved on: abort any running request and invalidate its
    // completion, even when the new query is empty or below threshold.
    _cancelInFlight();
    final token = ++_lastToken;

    if (query.trim().isEmpty) {
      state = const MapSearchState();
      return;
    }

    state = state.copyWith(
      query: query,
      searchResults: const AsyncValue<List<MapSearchResult>>.loading(),
    );

    _debounceTimer = Timer(_kDebounceDuration, () {
      _performSearch(query, token, origin);
    });
  }

  /// Clears query, results, and active timers.
  void clear() {
    _debounceTimer?.cancel();
    // Stop any request still running and drop its (now irrelevant) completion,
    // so it can't push a stale query/results back into the UI.
    _cancelInFlight();
    ++_lastToken;
    state = const MapSearchState();
  }

  /// Sets the selection and collapses the suggestions list.
  void select(MapSearchResult result) {
    _debounceTimer?.cancel();
    // A pick supersedes any in-flight search — cancel it and invalidate its
    // completion so it can't overwrite the selection.
    _cancelInFlight();
    ++_lastToken;
    state = state.copyWith(
      query: result.label,
      searchResults: const AsyncValue<List<MapSearchResult>>.data([]),
    );
  }

  Future<void> _performSearch(String query, int token, LatLng? origin) async {
    final cancelToken = CancelToken();
    _inFlightRequest = cancelToken;
    try {
      final results = await _searchSource.search(
        query,
        origin: origin,
        cancelToken: cancelToken,
      );
      if (token != _lastToken) return;

      state = state.copyWith(
        query: query,
        searchResults: AsyncValue<List<MapSearchResult>>.data(results),
      );
    } catch (error, stackTrace) {
      _logger.shout('Search failed for "$query"', error, stackTrace);
      if (token != _lastToken) return;
      state = state.copyWith(
        searchResults: AsyncValue<List<MapSearchResult>>.error(
          error,
          stackTrace,
        ),
      );
    } finally {
      if (identical(_inFlightRequest, cancelToken)) _inFlightRequest = null;
    }
  }
}
