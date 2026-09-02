import 'dart:ui';

const Locale appEnglishLocale = Locale('en');
const Locale appCzechLocale = Locale('cs');

/// Czech and Slovak users get Czech copy; every other system language falls
/// back to English instead of the template ARB locale.
///
/// Tag specificity is intentionally mixed: supported Czech/English device
/// locales keep their complete tag for backend negotiation, while Slovak and
/// unsupported UI languages resolve to the app's bare Czech/English fallback.
Locale resolveAppLocale(List<Locale>? preferredLocales) {
  for (final locale in preferredLocales ?? const <Locale>[]) {
    final languageCode = locale.languageCode.toLowerCase();
    if (languageCode == 'cs') {
      // Keep region/script subtags so localized backend requests can forward
      // the complete active Flutter locale (for example `cs-CZ`).
      return locale;
    }
    if (languageCode == 'sk') {
      return appCzechLocale;
    }
    if (languageCode == 'en') {
      // The generated app copy is shared by every English variant, but the
      // backend still needs the complete requested tag (`en-AU`, `en-US`, …).
      return locale;
    }
  }

  return appEnglishLocale;
}
