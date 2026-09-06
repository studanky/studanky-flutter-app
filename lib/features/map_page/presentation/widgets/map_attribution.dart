import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/core/platform/url_launcher_external_url_launcher.dart';

/// Mandatory Mapy.com attribution: a clickable logo plus the copyright text,
/// kept visible over the map as required by the API terms
/// (developer.mapy.com/.../atribution). Applies to the free tier too.
class MapAttribution extends ConsumerWidget {
  const MapAttribution({super.key});

  static const String _logoUrl = 'https://api.mapy.com/img/api/logo.svg';
  static final Uri _mapyUri = Uri.parse('https://mapy.com/');
  // static const String _copyrightUrl = 'https://api.mapy.com/copyright';
  // static const String _copyrightText = 'Seznam.cz a.s. a další';

  static final Logger _logger = Logger('MapAttribution');

  Future<void> _open(WidgetRef ref) async {
    try {
      await ref.read(externalUrlLauncherProvider).open(_mapyUri);
    } catch (error, stackTrace) {
      _logger.warning('Failed to open $_mapyUri', error, stackTrace);
    }
  }

  /// Kept visually prominent so contractual map attribution stays readable.
  static const double _watermarkOpacity = 0.65;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Opacity(
        opacity: _watermarkOpacity,
        child: Align(
          alignment: AlignmentGeometry.centerRight,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => unawaited(_open(ref)),
                behavior: HitTestBehavior.translucent,
                child: SvgPicture.network(
                  _logoUrl,
                  height: 30,
                  placeholderBuilder: (context) =>
                      const SizedBox(width: 86, height: 30),
                ),
              ),
              // GestureDetector(
              //   onTap: () => unawaited(_open(_copyrightUrl)),
              //   behavior: HitTestBehavior.translucent,
              //   child: Text(
              //     _copyrightText,
              //     style: context.appTextStyles.body2.copyWith(
              //       color: context.appColors.neutral900,
              //       decoration: TextDecoration.underline,
              //       decorationColor: context.appColors.neutral900,
              //       fontSize: 10,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
