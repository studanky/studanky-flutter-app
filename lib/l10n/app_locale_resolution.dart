import 'dart:ui';

const Locale appEnglishLocale = Locale('en');
const Locale appCzechLocale = Locale('cs');

/// Czech and Slovak users get Czech copy; every other system language falls
/// back to English instead of the template ARB locale.
Locale resolveAppLocale(List<Locale>? preferredLocales) {
  for (final locale in preferredLocales ?? const <Locale>[]) {
    final languageCode = locale.languageCode.toLowerCase();
    if (languageCode == 'cs' || languageCode == 'sk') {
      return appCzechLocale;
    }
    if (languageCode == 'en') {
      return appEnglishLocale;
    }
  }

  return appEnglishLocale;
}
