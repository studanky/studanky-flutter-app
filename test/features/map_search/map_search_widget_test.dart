import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_search/data/map_search_source.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_provider.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_source_provider.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_widget.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

class _RecordingSearchSource implements MapSearchSource {
  final List<String> queries = [];

  @override
  Future<List<MapSearchResult>> search(
    String query, {
    LatLng? origin,
    CancelToken? cancelToken,
  }) async {
    queries.add(query);
    return const [];
  }
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
        mapSearchSourceProvider(czech).overrideWithValue(czechSource),
        mapSearchSourceProvider(englishAu).overrideWithValue(englishSource),
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
}
