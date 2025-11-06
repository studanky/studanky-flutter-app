import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:studanky_flutter_app/core/app_constants.dart';
import 'package:studanky_flutter_app/features/map_page/providers/map_marker_repository_provider.dart';
import 'package:studanky_flutter_app/features/map_search/constants/map_search_constants.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_marker_repository_adapter.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_suggest_api_client.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_suggest_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';

final _dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: MapSearchConstants.suggestBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});

/// Provides the active search backend. Defaults to the Mapy.cz suggest API,
/// falling back to simple in-memory search when no API key is supplied.
final mapSearchSourceProvider = Provider<MapSearchSource>((ref) {
  const apiKey = AppConstants.mapyComApiKey;
  if (apiKey.isNotEmpty) {
    final apiClient = MapSuggestApiClient(
      dio: ref.watch(_dioProvider),
      apiKey: apiKey,
    );
    return MapSuggestSearchSource(apiClient: apiClient);
  }

  final repository = ref.watch(mapMarkerRepositoryProvider);
  return MapMarkerRepositoryAdapter(repository);
});

/// State consumed by the map search UI.
class MapSearchState {
  const MapSearchState({
    this.query = '',
    this.results = const [],
    this.isSearching = false,
    this.error,
    this.selected,
  });

  final String query;
  final List<MapSearchResult> results;
  final bool isSearching;
  final String? error;
  final MapSearchResult? selected;

  MapSearchState copyWith({
    String? query,
    List<MapSearchResult>? results,
    bool? isSearching,
    Object? error = _sentinel,
    Object? selected = _sentinel,
  }) {
    return MapSearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
      error: error == _sentinel ? this.error : error as String?,
      selected: selected == _sentinel
          ? this.selected
          : selected as MapSearchResult?,
    );
  }

  static const _sentinel = Object();
}

final mapSearchProvider =
    NotifierProvider.autoDispose<MapSearchNotifier, MapSearchState>(
      MapSearchNotifier.new,
    );

/// Debounced notifier that coordinates search requests and exposes results.
class MapSearchNotifier extends Notifier<MapSearchState> {
  static const Duration _debounceDuration = Duration(milliseconds: 250);

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
      isSearching: true,
      error: null,
      selected: null,
    );

    _debounceTimer = Timer(_debounceDuration, () {
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
      results: const [],
      isSearching: false,
      error: null,
      selected: result,
    );
  }

  Future<void> _performSearch(String query, int token) async {
    try {
      final results = await _searchSource.search(query);
      if (token != _lastToken) return;

      state = state.copyWith(
        query: query,
        results: results,
        isSearching: false,
        error: null,
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
        isSearching: false,
        error: 'Unable to search at the moment.',
        selected: null,
      );
    }
  }
}
