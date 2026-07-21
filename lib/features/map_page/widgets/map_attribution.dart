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
  static const String _copyrightText = 'Seznam.cz a.s. a další';

  static final Logger _logger = Logger('MapAttribution');

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (error, stackTrace) {
      _logger.warning('Failed to open $url', error, stackTrace);
    }
  }

  /// Kept visually prominent so contractual map attribution stays readable.
  static const double _watermarkOpacity = 0.65;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Opacity(
        opacity: _watermarkOpacity,
        child: Align(
          alignment: AlignmentGeometry.centerRight,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => unawaited(_open(_mapyUrl)),
                behavior: HitTestBehavior.translucent,
                child: SvgPicture.network(
                  _logoUrl,
                  height: 30,
                  placeholderBuilder: (context) =>
                      const SizedBox(width: 86, height: 30),
                ),
              ),
              GestureDetector(
                onTap: () => unawaited(_open(_copyrightUrl)),
                behavior: HitTestBehavior.translucent,
                child: Text(
                  _copyrightText,
                  style: Styles.textStyles.body2.copyWith(
                    color: Styles.appColors.neutral900,
                    decoration: TextDecoration.underline,
                    decorationColor: Styles.appColors.neutral900,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
