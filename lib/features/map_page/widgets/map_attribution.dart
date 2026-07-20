import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

/// Mandatory Mapy.com attribution: a clickable logo plus the copyright text,
/// kept visible over the map as required by the API terms
/// (developer.mapy.com/.../atribution). Applies to the free tier too.
class MapAttribution extends StatelessWidget {
  const MapAttribution({super.key});

  static const String _logoUrl = 'https://api.mapy.com/img/api/logo.svg';
  static const String _copyrightUrl = 'https://api.mapy.com/copyright';

  static final Logger _logger = Logger('MapAttribution');

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (error, stackTrace) {
      _logger.warning('Failed to open $url', error, stackTrace);
    }
  }

  /// Kept fully opaque so the contractual map attribution stays clearly
  /// visible over every tile.
  static const double _watermarkOpacity = 0.6;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Opacity(
        opacity: _watermarkOpacity,
        child: Align(
          alignment: AlignmentGeometry.centerRight,
          child: GestureDetector(
            onTap: () => unawaited(_open(_copyrightUrl)),
            behavior: HitTestBehavior.translucent,
            child: SvgPicture.network(
              _logoUrl,
              height: 30,
              placeholderBuilder: (context) =>
                  const SizedBox(width: 86, height: 30),
            ),
          ),
        ),
      ),
    );
  }
}
