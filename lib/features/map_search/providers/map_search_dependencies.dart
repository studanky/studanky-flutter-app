import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/interceptors/connectivity_interceptor.dart';
import 'package:studanky_flutter_app/core/api/interceptors/logging_interceptor.dart';
import 'package:studanky_flutter_app/core/connectivity/platform_connectivity_service.dart';
import 'package:studanky_flutter_app/core/env.dart';
import 'package:studanky_flutter_app/features/map_search/constants/map_search_constants.dart';
import 'package:studanky_flutter_app/features/map_search/data/composite_map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_repository.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_suggest_api.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_suggest_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/data/spring_map_search_source.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_repository.dart';

part 'map_search_dependencies.g.dart';

/// Isolated client for Mapy.com; the backend bearer token is never attached.
@Riverpod(keepAlive: true)
Dio mapSuggestDio(Ref ref) {
  final dio =
      Dio(
          BaseOptions(
            baseUrl: MapSearchConstants.suggestBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 10),
          ),
        )
        ..interceptors.addAll([
          ConnectivityInterceptor(ref.watch(connectivityServiceProvider)),
          LoggingInterceptor(),
        ]);

  ref.onDispose(dio.close);
  return dio;
}

@Riverpod(keepAlive: true)
MapSuggestApi mapSuggestApi(Ref ref) =>
    MapSuggestApi(ref.watch(mapSuggestDioProvider));

/// Locale-scoped data repository used by the presentation controller.
@Riverpod(keepAlive: true)
MapSearchRepository mapSearchRepository(Ref ref, Locale locale) {
  const apiKey = Env.mapyComApiKey;
  if (apiKey.isEmpty) {
    throw StateError(
      'Map search requires a Mapy.com API key. '
      'Provide MAPY_COM_API_KEY via --dart-define before building the app.',
    );
  }

  final repository = MapSearchRepositoryImpl(
    CompositeMapSearchSource([
      SpringMapSearchSource(
        repository: ref.watch(springRepositoryProvider),
        languageTag: locale.toLanguageTag(),
      ),
      MapSuggestSearchSource(
        api: ref.watch(mapSuggestApiProvider),
        apiKey: apiKey,
        languageCode: locale.languageCode,
      ),
    ]),
  );
  ref.onDispose(repository.cancel);
  return repository;
}
