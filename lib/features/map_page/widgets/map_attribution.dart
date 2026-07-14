import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:url_launcher/url_launcher.dart';

/// Mandatory Mapy.com attribution: a clickable logo plus the copyright text,
/// kept visible over the map as required by the API terms
/// (developer.mapy.com/.../atribution). Applies to the free tier too.
class MapAttribution extends StatelessWidget {
  const MapAttribution({super.key});

  static const String _logoUrl = 'https://api.mapy.com/img/api/logo.svg';
  static const String _mapyUrl = 'https://mapy.com/';
  static const String _copyrightUrl = 'https://api.mapy.com/copyright';
  static const String _copyrightText = 'Seznam.cz a.s. and others';

  static final Logger _logger = Logger('MapAttribution');

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (error, stackTrace) {
      _logger.warning('Failed to open $url', error, stackTrace);
    }
  }

  /// Watermark strength. Legible enough to satisfy the attribution terms, dim
  /// enough that it never competes with real UI.
  static const double _watermarkOpacity = 0.6;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final isDark = colors.brightness == Brightness.dark;

    // A deliberate *watermark*, not a control: no pill (a pill reads as a
    // button/chip), reduced opacity, just a soft shadow for worst-case
    // legibility. It must stay visually junior to the potability disclaimer
    // above it — legal presence, not an interaction target. The logo and text
    // still open the required pages, but nothing advertises tappability.
    final shadows = [
      Shadow(
        blurRadius: 4,
        color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.7),
      ),
    ];

    return Opacity(
      opacity: _watermarkOpacity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => unawaited(_open(_mapyUrl)),
            behavior: HitTestBehavior.translucent,
            child: SvgPicture.network(
              _logoUrl,
              height: 14,
              placeholderBuilder: (context) =>
                  const SizedBox(width: 40, height: 14),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => unawaited(_open(_copyrightUrl)),
            behavior: HitTestBehavior.translucent,
            child: Text(
              _copyrightText,
              style: text.body2.copyWith(
                fontSize: 10,
                color: colors.neutral700,
                shadows: shadows,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
