import 'package:url_launcher/url_launcher.dart';

/// Central place for legal/web placeholders used by the app UI.
///
/// Replace the placeholder operator values before release. The URLs are stable
/// public web routes; the web can go live after this app code lands.
class LegalConfig {
  const LegalConfig._();

  static const String operatorName = '[OPERATOR_NAME]';
  static const String operatorIco = '[OPERATOR_ICO]';
  static const String contactEmail = '[CONTACT_EMAIL]';

  static final Uri websiteUrl = Uri.parse('https://studankyapp.cz');
  static final Uri termsUrl = Uri.parse(
    'https://studankyapp.cz/podminky-uziti',
  );
  static final Uri privacyUrl = Uri.parse(
    'https://studankyapp.cz/ochrana-osobnich-udaju',
  );
  static final Uri dataSourcesUrl = Uri.parse(
    'https://studankyapp.cz/zdroje-dat',
  );
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
