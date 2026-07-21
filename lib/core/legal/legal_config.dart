import 'package:url_launcher/url_launcher.dart';

/// Central place for public legal routes used by the app UI.
class LegalConfig {
  const LegalConfig._();

  static final Uri websiteUrl = Uri.parse('https://studankyapp.cz');
  static final Uri termsUrl = Uri.parse('https://studankyapp.cz/terms-of-use');
  static final Uri privacyUrl = Uri.parse(
    'https://studankyapp.cz/privacy-policy',
  );
  static final Uri dataSourcesUrl = Uri.parse(
    'https://studankyapp.cz/data-sources',
  );
  static final Uri contactUrl = Uri.parse('https://studankyapp.cz/contact');
  static final Uri ccByUrl = Uri.parse(
    'https://creativecommons.org/licenses/by/4.0/',
  );
  static final Uri mapyCopyrightUrl = Uri.parse(
    'https://api.mapy.com/copyright',
  );

  static Future<bool> open(Uri uri) {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
