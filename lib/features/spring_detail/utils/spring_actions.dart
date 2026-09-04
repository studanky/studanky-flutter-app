import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studanky_flutter_app/core/navigation/deep_links.dart';
import 'package:studanky_flutter_app/features/springs/presentation/formatters/spring_formatters.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Outgoing actions from the detail sheet: share, open-on-map, copy. None hit
/// our backend — the map handoff is a client-built deeplink (api-reference.md
/// §4.4) resolved against the maps apps the user actually has installed.
class SpringActions {
  const SpringActions._();

  static final _logger = Logger('SpringActions');

  /// A Mapy.cz web link to the spring, used as the universal fallback when no
  /// maps app is installed for the "open on map" handoff.
  static String mapyUrl(LatLng position) =>
      'https://mapy.cz/zakladni?y=${position.latitude}&x=${position.longitude}&z=17';

  /// Shares the spring's name, coordinates and a deep link to it via the OS
  /// sheet. The link opens the app on this spring when installed, or routes to
  /// the store when not.
  static Future<void> share(
    AppLocalizations l10n, {
    required String documentId,
    required String name,
    required LatLng position,
  }) async {
    final text = l10n.spring_detail_share_text(
      name,
      SpringFormatters.coordinates(position),
      DeepLinks.springShareUrl(documentId),
    );
    await SharePlus.instance.share(ShareParams(text: text, subject: name));
  }

  /// Maps that can show a spring marker and that the app intentionally supports.
  /// Keeping this list explicit lets `map_launcher` tree-shake every unused map
  /// integration and keeps the iOS URL-scheme allowlist minimal.
  ///
  /// Note: dedicated outdoor apps (Komoot, Locus Map, …) are not in
  /// `map_launcher`'s catalogue, so they cannot be detected at all — among the
  /// supported apps only Mapy.com, OsmAnd and Maps.me are outdoor-capable.
  static const List<MapApp> _markerMaps = [
    MapApp.mapyCz, // Mapy.com — Czech outdoor (turistická/cyklo), first
    MapApp.osmand, // OsmAnd — offline topo, hiking & cycling
    MapApp.osmandplus, // OsmAnd+ (Android)
    MapApp.mapswithme, // Maps.me — OSM, outdoor-friendly, offline
    MapApp.apple, // anchor (always present on iOS)
    MapApp.google, // anchor (common everywhere)
    MapApp.here,
    MapApp.yandexMaps,
    MapApp.yandexNavi,
    MapApp.copilot,
  ];

  /// Preferred display order. Apps not listed keep their relative order and
  /// follow after the outdoor-first choices and platform anchors.
  static const List<MapApp> _preferredOrder = [
    MapApp.mapyCz,
    MapApp.osmand,
    MapApp.osmandplus,
    MapApp.mapswithme,
    MapApp.apple,
    MapApp.google,
  ];

  /// Orders [installed] outdoor-first by [_preferredOrder]; apps not listed keep
  /// their original relative order and follow the preferred ones. Filters
  /// nothing — the user chooses from every installed maps app. Pure (no platform
  /// calls) so it can be unit-tested.
  @visibleForTesting
  static List<SupportedMap> orderForDisplay(List<SupportedMap> installed) {
    final byId = {for (final map in installed) map.map.id: map};
    final preferredIds = _preferredOrder.map((map) => map.id).toSet();
    return [
      for (final map in _preferredOrder) ?byId[map.id],
      for (final map in installed)
        if (!preferredIds.contains(map.map.id)) map,
    ];
  }

  /// Supported maps that can show this marker and are actually installed on the
  /// device, ordered outdoor-first. Universal-link browser fallbacks returned
  /// by `map_launcher` are excluded because this flow has one explicit web
  /// fallback. Empty on failure so the caller can use that fallback.
  static Future<List<SupportedMap>> installedMaps({
    required LatLng position,
    required String title,
  }) async {
    try {
      final request = MapLauncher.marker(
        Location.coords(position.latitude, position.longitude, title: title),
        zoom: 17,
      );
      final supported = await request.getSupportedMaps(_markerMaps);
      return orderForDisplay(
        supported.where((map) => map.isInstalled).toList(),
      );
    } catch (error, stackTrace) {
      _logger.warning('Failed to query installed maps', error, stackTrace);
      return const [];
    }
  }

  /// Opens the spring as a pinned marker (not turn-by-turn navigation) in [map].
  /// The marker request is retained by the launchable map returned above.
  /// Returns false if the app could not be launched.
  static Future<bool> showMarker(SupportedMap map) async {
    try {
      await map.show();
      return true;
    } catch (error, stackTrace) {
      _logger.warning('Failed to open ${map.name}', error, stackTrace);
      return false;
    }
  }

  /// Web fallback when no maps app is installed: opens the Mapy.cz location in
  /// the browser. Returns false if even that fails.
  static Future<bool> openInBrowser(LatLng position) async {
    final uri = Uri.parse(mapyUrl(position));
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (error, stackTrace) {
      _logger.warning('Failed to launch $uri', error, stackTrace);
      return false;
    }
  }

  /// Copies the coordinates to the clipboard.
  static Future<void> copyCoordinates(LatLng position) {
    return Clipboard.setData(
      ClipboardData(text: SpringFormatters.coordinates(position)),
    );
  }
}
