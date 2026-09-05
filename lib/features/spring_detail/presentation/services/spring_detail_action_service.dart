import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/navigation/deep_links.dart';
import 'package:studanky_flutter_app/features/spring_detail/data/services/spring_clipboard_service.dart';
import 'package:studanky_flutter_app/features/spring_detail/data/services/spring_map_service.dart';
import 'package:studanky_flutter_app/features/spring_detail/data/services/spring_share_service.dart';
import 'package:studanky_flutter_app/features/springs/presentation/formatters/spring_formatters.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

class SpringDetailActionService {
  const SpringDetailActionService(
    this._shareService,
    this._mapService,
    this._clipboardService,
  );

  final SpringShareService _shareService;
  final SpringMapService _mapService;
  final SpringClipboardService _clipboardService;

  Future<void> share(
    AppLocalizations l10n, {
    required String documentId,
    required String name,
    required LatLng position,
  }) {
    return _shareService.share(
      text: l10n.spring_detail_share_text(
        name,
        SpringFormatters.coordinates(position),
        DeepLinks.springShareUrl(documentId),
      ),
      subject: name,
    );
  }

  Future<List<SpringMapOption>> installedMaps({
    required LatLng position,
    required String title,
  }) => _mapService.installedMaps(position: position, title: title);

  Future<bool> openMap(SpringMapOption option) => _mapService.open(option);

  Future<bool> openMapFallback(LatLng position) =>
      _mapService.openWebFallback(position);

  Future<void> copyCoordinates(LatLng position) =>
      _clipboardService.copy(SpringFormatters.coordinates(position));
}

final springDetailActionServiceProvider = Provider<SpringDetailActionService>((
  ref,
) {
  return SpringDetailActionService(
    ref.watch(springShareServiceProvider),
    ref.watch(springMapServiceProvider),
    ref.watch(springClipboardServiceProvider),
  );
});
