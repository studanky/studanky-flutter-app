import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/spring_detail/data/services/spring_clipboard_service.dart';
import 'package:studanky_flutter_app/features/spring_detail/data/services/spring_map_service.dart';
import 'package:studanky_flutter_app/features/spring_detail/data/services/spring_share_service.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/services/spring_detail_action_service.dart';
import 'package:studanky_flutter_app/l10n/app_localizations_cs.dart';

class _FakeShareService implements SpringShareService {
  String? text;
  String? subject;

  @override
  Future<void> share({required String text, required String subject}) async {
    this.text = text;
    this.subject = subject;
  }
}

class _FakeMapService implements SpringMapService {
  LatLng? installedPosition;
  String? installedTitle;
  LatLng? fallbackPosition;

  @override
  Future<List<SpringMapOption>> installedMaps({
    required LatLng position,
    required String title,
  }) async {
    installedPosition = position;
    installedTitle = title;
    return const [];
  }

  @override
  Future<bool> open(SpringMapOption option) async => true;

  @override
  Future<bool> openWebFallback(LatLng position) async {
    fallbackPosition = position;
    return true;
  }
}

class _FakeClipboardService implements SpringClipboardService {
  String? text;

  @override
  Future<void> copy(String text) async {
    this.text = text;
  }
}

void main() {
  const position = LatLng(50.0755, 14.4378);
  late _FakeShareService share;
  late _FakeMapService maps;
  late _FakeClipboardService clipboard;
  late SpringDetailActionService actions;

  setUp(() {
    share = _FakeShareService();
    maps = _FakeMapService();
    clipboard = _FakeClipboardService();
    actions = SpringDetailActionService(share, maps, clipboard);
  });

  test(
    'builds localized share content with coordinates and public URL',
    () async {
      await actions.share(
        AppLocalizationsCs(),
        documentId: 'abc 123',
        name: 'Lesní pramen',
        position: position,
      );

      expect(share.subject, 'Lesní pramen');
      expect(
        share.text,
        'Lesní pramen\n50.0755000N, 14.4378000E\n'
        'https://studankyapp.cz/s/abc%20123',
      );
    },
  );

  test('delegates map discovery, fallback and clipboard commands', () async {
    await actions.installedMaps(position: position, title: 'Pramen');
    expect(maps.installedPosition, position);
    expect(maps.installedTitle, 'Pramen');

    expect(await actions.openMapFallback(position), isTrue);
    expect(maps.fallbackPosition, position);

    await actions.copyCoordinates(position);
    expect(clipboard.text, '50.0755000N, 14.4378000E');
  });
}
