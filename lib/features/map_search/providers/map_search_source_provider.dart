import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/app_constants.dart';
import 'package:studanky_flutter_app/features/map_search/constants/map_search_constants.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_suggest_api_client.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_suggest_search_source.dart';

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

/// Provides the active search backend. Requires the Mapy.cz suggest API.
final mapSearchSourceProvider = Provider<MapSearchSource>((ref) {
  const apiKey = AppConstants.mapyComApiKey;
  if (apiKey.isEmpty) {
    throw StateError(
      'Map search requires a Mapy.cz API key. '
      'Set AppConstants.mapyComApiKey before building the app.',
    );
  }

  final apiClient = MapSuggestApiClient(
    dio: ref.watch(_dioProvider),
    apiKey: apiKey,
  );
  return MapSuggestSearchSource(apiClient: apiClient);
});
