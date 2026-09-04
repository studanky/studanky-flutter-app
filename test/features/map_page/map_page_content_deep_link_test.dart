import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/core/providers/connectivity_status_provider.dart';
import 'package:studanky_flutter_app/core/providers/shared_preferences_provider.dart';
import 'package:studanky_flutter_app/features/map_page/map_page_content.dart';
import 'package:studanky_flutter_app/features/map_page/providers/user_location_provider.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/platform_config.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/data/spring_detail_repository.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/report_page.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/spring_detail.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/spring_detail_sheet.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_marker_source.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';
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

class _ControlledSpringDetailRepository implements SpringDetailRepository {
  final Completer<ApiResult<SpringDetail>> _detail = Completer();
  int detailCalls = 0;

  void completeDetail(SpringDetail detail) {
    _detail.complete(ApiResult.success(detail));
  }

  @override
  Future<ApiResult<SpringDetail>> fetchDetail({
    required String documentId,
    required String languageTag,
  }) {
    detailCalls++;
    return _detail.future;
  }

  @override
  Future<ApiResult<ReportPage>> fetchReports(
    String documentId, {
    required int page,
    int pageSize = 20,
  }) async => const ApiResult.success(
    ReportPage(items: [], page: 1, pageCount: 1, total: 0),
  );
}

class _OnlineConnectivityController extends ConnectivityController {
  @override
  ConnectivityStatus build() => ConnectivityStatus.online;
}

class _GrantedLocationService implements UserLocationService {
  final StreamController<Position> positions =
      StreamController<Position>.broadcast();

  @override
  Future<bool> isLocationServiceEnabled() async => true;

  @override
  Future<LocationPermission> checkPermission() async =>
      LocationPermission.whileInUse;

  @override
  Future<LocationPermission> requestPermission() async =>
      LocationPermission.whileInUse;

  @override
  Stream<Position> getPositionStream({
    required LocationSettings locationSettings,
  }) => positions.stream;

  void emit(LatLng position) {
    positions.add(
      Position(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime(2026, 9, 4),
        accuracy: 5,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      ),
    );
  }

  Future<void> dispose() => positions.close();
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

SpringDetail _detail(String documentId, LatLng position) => SpringDetail(
  documentId: documentId,
  name: 'Linked spring',
  position: position,
  status: SpringStatus.unknown,
);

Widget _app(ProviderContainer container, String? documentId) =>
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: const Locale('cs'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: MapPageContent(detailDocumentId: documentId)),
      ),
    );

MapController _mapController(WidgetTester tester) =>
    tester.widget<FlutterMap>(find.byType(FlutterMap)).mapController!;

Future<ProviderContainer> _container({
  required _ControlledSpringDetailRepository repository,
  bool legalAcknowledged = false,
  UserLocationService? locationService,
}) async {
  SharedPreferences.setMockInitialValues({
    if (legalAcknowledged) 'legal_onboarding_ack_v1': true,
  });
  final preferences = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),
      platformConfigControllerProvider.overrideWithValue(
        PlatformConfig.fallback,
      ),
      connectivityStatusProvider.overrideWith(
        _OnlineConnectivityController.new,
      ),
      springMarkerSourceProvider.overrideWithValue(_EmptyMarkerSource()),
      springDetailRepositoryProvider.overrideWithValue(repository),
      if (locationService != null)
        userLocationServiceProvider.overrideWithValue(locationService),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> _finishTest(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 500));
}

void _expectSpringInVisibleMapStrip(
  MapController controller,
  LatLng springPosition,
) {
  final camera = controller.camera;
  final springOffset = camera.latLngToScreenOffset(springPosition);
  final sheetTop =
      camera.nonRotatedSize.height * (1 - SpringDetailSheet.initialSize);
  const downwardOffset = 24.0;

  expect(camera.zoom, closeTo(17, 0.001));
  expect(springOffset.dx, closeTo(camera.nonRotatedSize.width / 2, 0.5));
  expect(springOffset.dy, closeTo(sheetTop / 2 + downwardOffset, 0.5));
}

void main() {
  setUp(() async {
    await _cacheMapAttributionLogo();
  });

  tearDown(svg.cache.clear);

  testWidgets(
    'deep-link detail focuses a cached spring once without a duplicate request',
    (tester) async {
      const documentId = 'linked-spring';
      const position = LatLng(50.0755, 14.4378);
      final repository = _ControlledSpringDetailRepository()
        ..completeDetail(_detail(documentId, position));
      final container = await _container(repository: repository);

      await tester.pumpWidget(_app(container, documentId));
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));

      _expectSpringInVisibleMapStrip(_mapController(tester), position);
      expect(repository.detailCalls, 1);
      expect(tester.takeException(), isNull);

      await _finishTest(tester);
    },
  );

  testWidgets('automatic user location does not override deep-link focus', (
    tester,
  ) async {
    const documentId = 'linked-spring';
    const springPosition = LatLng(49.1951, 16.6068);
    const userPosition = LatLng(50.0755, 14.4378);
    final repository = _ControlledSpringDetailRepository();
    final locationService = _GrantedLocationService();
    addTearDown(locationService.dispose);
    final container = await _container(
      repository: repository,
      legalAcknowledged: true,
      locationService: locationService,
    );

    await tester.pumpWidget(_app(container, documentId));
    await tester.pump();
    await tester.pump();
    expect(container.read(userLocationProvider).activated, isTrue);

    repository.completeDetail(_detail(documentId, springPosition));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    locationService.emit(userPosition);
    await tester.pump();

    _expectSpringInVisibleMapStrip(_mapController(tester), springPosition);
    expect(tester.takeException(), isNull);

    await _finishTest(tester);
  });

  testWidgets('late detail response cannot focus a closed spring route', (
    tester,
  ) async {
    const documentId = 'linked-spring';
    const position = LatLng(50.0755, 14.4378);
    final repository = _ControlledSpringDetailRepository();
    final container = await _container(repository: repository);

    await tester.pumpWidget(_app(container, documentId));
    await tester.pump();
    final controller = _mapController(tester);
    final initialCenter = controller.camera.center;
    final initialZoom = controller.camera.zoom;

    await tester.pumpWidget(_app(container, null));
    repository.completeDetail(_detail(documentId, position));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(controller.camera.center.latitude, initialCenter.latitude);
    expect(controller.camera.center.longitude, initialCenter.longitude);
    expect(controller.camera.zoom, initialZoom);
    expect(tester.takeException(), isNull);

    await _finishTest(tester);
  });
}
