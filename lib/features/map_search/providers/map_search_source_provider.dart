import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/interceptors/connectivity_interceptor.dart';
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
          // Broadens the offline signal to the Mapy.com host too. Cancelled suggest
          // requests (search debounce) classify as inconclusive, so typing never
          // flips connectivity. Connectivity before logging (Dio keeps logging last).
          ConnectivityInterceptor(ref),
          LoggingInterceptor(),
        ]);

  ref.onDispose(dio.close);
  return dio;
}

@Riverpod(keepAlive: true)
MapSuggestApi mapSuggestApi(Ref ref) =>
    MapSuggestApi(ref.watch(mapSuggestDioProvider));

/// Provides the active search backend. Requires the Mapy.com suggest API.
///
/// Kept alive so the first-party result cache survives between debounced
/// keystrokes instead of being rebuilt on every `ref.read`. The search notifier
/// explicitly invalidates its previous locale family on a language switch.
/// The final retained source is bounded to 64 first-party result lists.
@Riverpod(keepAlive: true)
MapSearchSource mapSearchSource(Ref ref, Locale locale) {
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
      languageTag: locale.toLanguageTag(),
      springLabel: lookupAppLocalizations(
        Locale(locale.languageCode),
      ).map_search_type_spring,
    ),
    MapSuggestSearchSource(
      api: ref.watch(mapSuggestApiProvider),
      apiKey: apiKey,
      languageCode: locale.languageCode,
    ),
  ]);
}
