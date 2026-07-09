import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studanky_flutter_app/core/navigation/deep_links.dart';
import 'package:studanky_flutter_app/features/spring_detail/utils/spring_formatters.dart';
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

  /// Preferred display order. A spring is reached on foot or by bike, so
  /// outdoor/hiking/cycling maps lead — Mapy.com first, then OsmAnd and Maps.me
  /// — with Apple and Google Maps as universal anchors. This only *orders* the
  /// list; nothing is filtered out, so the user always picks from every maps app
  /// they have installed. Apps not listed keep their order and follow after.
  ///
  /// Note: dedicated outdoor apps (Komoot, Locus Map, …) are not in
  /// `map_launcher`'s catalogue, so they cannot be detected at all — among the
  /// supported apps only Mapy.com, OsmAnd and Maps.me are outdoor-capable.
  static const List<MapType> _preferredOrder = [
    MapType.mapyCz, // Mapy.com — Czech outdoor (turistická/cyklo), first
    MapType.osmand, // OsmAnd — offline topo, hiking & cycling
    MapType.osmandplus, // OsmAnd+
    MapType.mapswithme, // Maps.me — OSM, outdoor-friendly, offline
    MapType.apple, // anchor (always present on iOS)
    MapType.google, // anchor (common everywhere)
  ];

  /// Orders [installed] outdoor-first by [_preferredOrder]; apps not listed keep
  /// their original relative order and follow the preferred ones. Filters
  /// nothing — the user chooses from every installed maps app. Pure (no platform
  /// calls) so it can be unit-tested.
  @visibleForTesting
  static List<AvailableMap> orderForDisplay(List<AvailableMap> installed) {
    final byType = {for (final map in installed) map.mapType: map};
    final preferredTypes = _preferredOrder.toSet();
    return [
      for (final type in _preferredOrder) ?byType[type],
      for (final map in installed)
        if (!preferredTypes.contains(map.mapType)) map,
    ];
  }

  /// Every maps app actually installed on the device, ordered outdoor-first.
  /// Already limited to what the user has, so they only ever see apps they can
  /// open. Empty when no maps app is installed (or on failure), so the caller
  /// can fall back to the web link.
  static Future<List<AvailableMap>> installedMaps() async {
    try {
      return orderForDisplay(await MapLauncher.installedMaps);
    } catch (error, stackTrace) {
      _logger.warning('Failed to query installed maps', error, stackTrace);
      return const [];
    }
  }

  /// Opens the spring as a pinned marker (not turn-by-turn navigation) in [map],
  /// labelled with [title]. Returns false if the app could not be launched.
  static Future<bool> showMarker(
    AvailableMap map, {
    required LatLng position,
    required String title,
  }) async {
    try {
      await map.showMarker(
        coords: Coords(position.latitude, position.longitude),
        title: title,
      );
      return true;
    } catch (error, stackTrace) {
      _logger.warning('Failed to open ${map.mapName}', error, stackTrace);
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
