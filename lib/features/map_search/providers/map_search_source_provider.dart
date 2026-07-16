import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/interceptors/logging_interceptor.dart';
import 'package:studanky_flutter_app/core/env.dart';
import 'package:studanky_flutter_app/features/map_search/constants/map_search_constants.dart';
import 'package:studanky_flutter_app/features/map_search/data/composite_map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_suggest_api.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_suggest_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/data/spring_map_search_source.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_repository.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

part 'map_search_source_provider.g.dart';

/// Dedicated Dio for the third-party Mapy.com API.
///
/// Intentionally separate from the Strapi client so the backend bearer token
/// is never attached to cross-origin requests.
@Riverpod(keepAlive: true)
Dio mapSuggestDio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: MapSearchConstants.suggestBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(LoggingInterceptor());

  ref.onDispose(dio.close);
  return dio;
}

@Riverpod(keepAlive: true)
MapSuggestApi mapSuggestApi(Ref ref) =>
    MapSuggestApi(ref.watch(mapSuggestDioProvider));

/// Provides the active search backend. Requires the Mapy.com suggest API.
///
/// Kept alive so the first-party result cache survives between debounced
/// keystrokes instead of being rebuilt on every `ref.read`.
@Riverpod(keepAlive: true)
MapSearchSource mapSearchSource(Ref ref, String languageCode) {
  const apiKey = Env.mapyComApiKey;
  if (apiKey.isEmpty) {
    throw StateError(
      'Map search requires a Mapy.com API key. '
      'Provide MAPY_COM_API_KEY via --dart-define before building the app.',
    );
  }

  return CompositeMapSearchSource([
    SpringMapSearchSource(
      repository: ref.watch(springRepositoryProvider),
      languageCode: languageCode,
      springLabel: lookupAppLocalizations(
        Locale(languageCode),
      ).map_search_type_spring,
    ),
    MapSuggestSearchSource(
      api: ref.watch(mapSuggestApiProvider),
      apiKey: apiKey,
      languageCode: languageCode,
    ),
  ]);
}
