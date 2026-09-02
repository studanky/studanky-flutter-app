import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/l10n/app_locale_resolution.dart';

void main() {
  test('uses Czech for Czech systems', () {
    expect(resolveAppLocale(const [Locale('cs')]), appCzechLocale);
  });

  test('preserves region and script subtags for supported languages', () {
    const czech = Locale('cs', 'CZ');
    const englishUs = Locale('en', 'US');
    const englishAu = Locale('en', 'AU');
    const englishWithScript = Locale.fromSubtags(
      languageCode: 'en',
      scriptCode: 'Latn',
      countryCode: 'US',
    );

    expect(resolveAppLocale(const [czech]).toLanguageTag(), 'cs-CZ');
    expect(resolveAppLocale(const [englishUs]).toLanguageTag(), 'en-US');
    expect(resolveAppLocale(const [englishAu]).toLanguageTag(), 'en-AU');
    expect(
      resolveAppLocale(const [englishWithScript]).toLanguageTag(),
      'en-Latn-US',
    );
  });

  test('uses Czech for Slovak systems', () {
    expect(resolveAppLocale(const [Locale('sk')]), appCzechLocale);
  });

  test('uses English for English systems', () {
    expect(resolveAppLocale(const [Locale('en')]), appEnglishLocale);
  });

  test('falls back to English for every other system language', () {
    expect(resolveAppLocale(const [Locale('de')]), appEnglishLocale);
    expect(resolveAppLocale(const [Locale('fr')]), appEnglishLocale);
    expect(resolveAppLocale(const [Locale('pl')]), appEnglishLocale);
  });
}
