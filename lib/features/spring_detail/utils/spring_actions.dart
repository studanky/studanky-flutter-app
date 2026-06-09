import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studanky_flutter_app/features/spring_detail/utils/spring_formatters.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Outgoing actions from the detail sheet: share, navigate, copy. None hit our
/// backend — navigation is a client-built deeplink (api-reference.md §4.4).
class SpringActions {
  const SpringActions._();

  static final _logger = Logger('SpringActions');

  /// A Mapy.cz web link to the spring, used in the share payload and as the
  /// universal navigation fallback.
  static String mapyUrl(LatLng position) =>
      'https://mapy.cz/zakladni?y=${position.latitude}&x=${position.longitude}&z=17';

  /// Shares the spring's name, coordinates and a map link via the OS sheet.
  static Future<void> share(
    AppLocalizations l10n, {
    required String name,
    required LatLng position,
  }) async {
    final text = l10n.spring_detail_share_text(
      name,
      SpringFormatters.coordinates(position),
      mapyUrl(position),
    );
    await SharePlus.instance.share(ShareParams(text: text, subject: name));
  }

  /// Opens turn-by-turn navigation in the user's preferred maps app, falling
  /// back through platform-native schemes to the Mapy.cz web link.
  ///
  /// Returns false if nothing could be launched.
  static Future<bool> navigate(LatLng position) async {
    final lat = position.latitude;
    final lng = position.longitude;

    final candidates = <Uri>[
      if (Platform.isIOS)
        Uri.parse('https://maps.apple.com/?daddr=$lat,$lng&dirflg=w'),
      if (Platform.isAndroid) Uri.parse('geo:$lat,$lng?q=$lat,$lng'),
      Uri.parse(mapyUrl(position)),
    ];

    for (final uri in candidates) {
      try {
        if (await canLaunchUrl(uri) &&
            await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          return true;
        }
      } catch (error, stackTrace) {
        _logger.warning('Failed to launch $uri', error, stackTrace);
      }
    }
    return false;
  }

  /// Copies the coordinates to the clipboard.
  static Future<void> copyCoordinates(LatLng position) {
    return Clipboard.setData(
      ClipboardData(text: SpringFormatters.coordinates(position)),
    );
  }
}
