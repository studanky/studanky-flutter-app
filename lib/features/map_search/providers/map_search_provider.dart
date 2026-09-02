import 'dart:async';
import 'dart:ui';

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

final mapSearchProvider =
    NotifierProvider.autoDispose<MapSearchNotifier, MapSearchState>(
      MapSearchNotifier.new,
    );

/// Debounced notifier that coordinates search requests and exposes results.
///
/// This intentionally is not a locale-keyed family: the query is ephemeral UI
/// state and must survive an OS locale change. Locale-dependent search sources
/// are families instead, while [updateLocale] cancels/repeats only an active
/// query against the newly selected source.
class MapSearchNotifier extends Notifier<MapSearchState> {
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

  Locale? _locale;
  bool _hasActiveQuery = false;

  MapSearchSource _searchSource(Locale locale) =>
      ref.read(mapSearchSourceProvider(locale));

  bool _activateLocale(Locale locale) {
    final previous = _locale;
    if (previous == locale) return false;
    _locale = locale;

    // The source family is keepAlive so its small first-party query cache
    // survives debounce reads. Explicitly evict the previous locale on a switch
    // so repeated OS-language changes cannot accumulate immortal families.
    if (previous != null) ref.invalidate(mapSearchSourceProvider(previous));
    return true;
  }

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
  void setQuery(String query, {required Locale locale, LatLng? origin}) {
    final localeChanged = _activateLocale(locale);
    if (query == state.query && !localeChanged) {
      return;
    }

    _debounceTimer?.cancel();
    // The query moved on: abort any running request and invalidate its
    // completion, even when the new query is empty or below threshold.
    _cancelInFlight();
    final token = ++_lastToken;

    if (query.trim().isEmpty) {
      _hasActiveQuery = false;
      state = const MapSearchState();
      return;
    }

    _hasActiveQuery = true;
    state = state.copyWith(
      query: query,
      searchResults: const AsyncValue<List<MapSearchResult>>.loading(),
    );

    _debounceTimer = Timer(_kDebounceDuration, () {
      _performSearch(query, token, origin, locale);
    });
  }

  /// Switches both search backends to [locale] without discarding what the
  /// user typed. An active query is repeated and any old-locale completion is
  /// cancelled or rejected by its request token.
  void updateLocale(Locale locale, {LatLng? origin}) {
    if (!_activateLocale(locale)) return;

    _debounceTimer?.cancel();
    _cancelInFlight();
    final token = ++_lastToken;
    final query = state.query;
    if (!_hasActiveQuery) return;

    state = state.copyWith(
      searchResults: const AsyncValue<List<MapSearchResult>>.loading(),
    );
    _debounceTimer = Timer(_kDebounceDuration, () {
      _performSearch(query, token, origin, locale);
    });
  }

  /// Clears query, results, and active timers.
  void clear() {
    _debounceTimer?.cancel();
    // Stop any request still running and drop its (now irrelevant) completion,
    // so it can't push a stale query/results back into the UI.
    _cancelInFlight();
    ++_lastToken;
    _hasActiveQuery = false;
    state = const MapSearchState();
  }

  /// Sets the selection and collapses the suggestions list.
  void select(MapSearchResult result) {
    _debounceTimer?.cancel();
    // A pick supersedes any in-flight search — cancel it and invalidate its
    // completion so it can't overwrite the selection.
    _cancelInFlight();
    ++_lastToken;
    _hasActiveQuery = false;
    state = state.copyWith(
      query: result.label,
      searchResults: const AsyncValue<List<MapSearchResult>>.data([]),
    );
  }

  Future<void> _performSearch(
    String query,
    int token,
    LatLng? origin,
    Locale locale,
  ) async {
    final cancelToken = CancelToken();
    _inFlightRequest = cancelToken;
    try {
      final results = await _searchSource(
        locale,
      ).search(query, origin: origin, cancelToken: cancelToken);
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
