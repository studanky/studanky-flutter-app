import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/core/providers/connectivity_status_provider.dart';
import 'package:studanky_flutter_app/core/providers/shared_preferences_provider.dart';
import 'package:studanky_flutter_app/features/map_page/map_page_content.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/platform_config.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_marker_source.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';
import 'package:studanky_flutter_app/features/springs/providers/spring_markers_provider.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

class _EmptyMarkerSource implements SpringMarkerSource {
  final Set<String> loadedLanguageTags = {};

  @override
  bool covers(SpringBounds bounds, {required String languageTag}) =>
      loadedLanguageTags.contains(languageTag);

  @override
  bool hasDataFor(SpringBounds bounds, {required String languageTag}) =>
      loadedLanguageTags.contains(languageTag);

  @override
  Future<ApiResult<List<SpringMarkerEntity>>> load(
    SpringBounds bounds, {
    required String languageTag,
  }) async {
    loadedLanguageTags.add(languageTag);
    return const ApiResult.success([]);
  }
}

class _OnlineConnectivityController extends ConnectivityController {
  @override
  ConnectivityStatus build() => ConnectivityStatus.online;
}

Future<void> _cacheMapAttributionLogo() async {
  const networkLoader = SvgNetworkLoader(
    'https://api.mapy.com/img/api/logo.svg',
  );
  final logo = await const SvgStringLoader(
    '<svg xmlns="http://www.w3.org/2000/svg" width="1" height="1" '
    'viewBox="0 0 1 1"><path d="M0 0h1v1H0z"/></svg>',
  ).loadBytes(null);
  await svg.cache.putIfAbsent(networkLoader.cacheKey(null), () async => logo);
}

void main() {
  testWidgets(
    'mount and locale flip update marker language outside widget build',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await _cacheMapAttributionLogo();
      addTearDown(svg.cache.clear);
      final preferences = await SharedPreferences.getInstance();
      final markerSource = _EmptyMarkerSource();
      const detailMarker = SpringMarkerEntity(
        documentId: 'test',
        name: 'Test spring',
        position: LatLng(50, 14),
        status: SpringStatus.unknown,
      );
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          platformConfigControllerProvider.overrideWithValue(
            PlatformConfig.fallback,
          ),
          connectivityStatusProvider.overrideWith(
            _OnlineConnectivityController.new,
          ),
          springMarkerSourceProvider.overrideWithValue(markerSource),
        ],
      );
      addTearDown(container.dispose);

      Widget app(Locale locale) => UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: locale,
          localeListResolutionCallback: (_, _) => locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MapPageContent(
              detailDocumentId: detailMarker.documentId,
              detailMarker: detailMarker,
            ),
          ),
        ),
      );

      await tester.pumpWidget(app(const Locale('cs')));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(container.read(springMarkersProvider).languageTag, 'cs');

      await tester.pumpWidget(app(const Locale('en', 'AU')));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(container.read(springMarkersProvider).languageTag, 'en-AU');

      // Exercise the semantic zoom step so MapPageContent's lazy camera
      // animator is initialized before the widget is disposed.
      final semantics = tester.ensureSemantics();
      tester.semantics.increase(
        find.semantics.byAction(SemanticsAction.increase),
      );
      await tester.pump(const Duration(milliseconds: 500));
      semantics.dispose();

      // Drain the map's short camera/empty-state timers, then unmount it.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 500));
    },
  );
}
