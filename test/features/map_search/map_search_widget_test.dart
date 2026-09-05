import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_light.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_repository.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result_type.dart';
import 'package:studanky_flutter_app/features/map_search/presentation/widgets/map_search_result_list.dart';
import 'package:studanky_flutter_app/features/map_search/presentation/widgets/map_search_widget.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_dependencies.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_provider.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

class _RecordingSearchSource implements MapSearchRepository {
  final List<String> queries = [];

  @override
  Future<List<MapSearchResult>> search(String query, {LatLng? origin}) async {
    queries.add(query);
    return const [];
  }

  @override
  void cancel() {}
}

void main() {
  testWidgets('locale flip preserves a short query and settles its spinner', (
    tester,
  ) async {
    const czech = Locale('cs');
    const englishAu = Locale('en', 'AU');
    final czechSource = _RecordingSearchSource();
    final englishSource = _RecordingSearchSource();
    final container = ProviderContainer(
      overrides: [
        mapSearchRepositoryProvider(czech).overrideWithValue(czechSource),
        mapSearchRepositoryProvider(englishAu).overrideWithValue(englishSource),
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
        home: const Scaffold(
          body: MapSearchWidget(key: ValueKey('search'), hintText: 'Search'),
        ),
      ),
    );

    await tester.pumpWidget(app(czech));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'o');
    await tester.pump();

    final progressIndicator = find.byWidgetPredicate(
      (widget) =>
          widget is CircularProgressIndicator ||
          widget is CupertinoActivityIndicator,
    );

    expect(container.read(mapSearchProvider).searchResults.isLoading, isTrue);
    expect(progressIndicator, findsOneWidget);
    expect(
      tester
          .widget<CircularProgressIndicator>(
            find.byType(CircularProgressIndicator),
          )
          .valueColor
          ?.value,
      AppColors.fromScheme(AppColorsLight()).primaryMain,
    );

    // Rebuild with another full locale before the original 300 ms debounce.
    await tester.pumpWidget(app(englishAu));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 301));
    await tester.pump();

    expect(czechSource.queries, isEmpty);
    expect(englishSource.queries, ['o']);
    expect(find.text('o'), findsOneWidget);
    expect(progressIndicator, findsNothing);
    expect(container.read(mapSearchProvider).searchResults.value, isEmpty);
  });

  testWidgets('result type icons use the shared brand accent', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: MapSearchResultList(
            results: const [
              MapSearchResult(
                label: 'Studánka',
                subtitle: 'Jeseníky',
                position: LatLng(50, 17),
                type: MapSearchResultType.spring,
              ),
            ],
            onTap: (_) {},
          ),
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byIcon(Icons.water_drop_rounded));
    expect(icon.color, AppColors.fromScheme(AppColorsLight()).primaryMain);
  });

  testWidgets('formats structured spring distance in the active locale', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('cs'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: MapSearchResultList(
            results: const [
              MapSearchResult(
                label: 'Ostružná',
                position: LatLng(50.18, 17.05),
                type: MapSearchResultType.spring,
                distanceMeters: 2310,
              ),
            ],
            onTap: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Studánka • 2,3 km'), findsOneWidget);
  });
}
