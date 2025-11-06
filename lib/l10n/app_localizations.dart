import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('cs')];

  /// No description provided for @bottom_nav_bar_item_map.
  ///
  /// In cs, this message translates to:
  /// **'Mapa'**
  String get bottom_nav_bar_item_map;

  /// No description provided for @bottom_nav_bar_item_scanner.
  ///
  /// In cs, this message translates to:
  /// **'QR sken'**
  String get bottom_nav_bar_item_scanner;

  /// No description provided for @auth_error_provider_disabled.
  ///
  /// In cs, this message translates to:
  /// **'Tento způsob přihlášení není povolen'**
  String get auth_error_provider_disabled;

  /// No description provided for @auth_error_invalid_credentials.
  ///
  /// In cs, this message translates to:
  /// **'Neplatné přihlašovací údaje'**
  String get auth_error_invalid_credentials;

  /// No description provided for @auth_error_email_not_confirmed.
  ///
  /// In cs, this message translates to:
  /// **'Váš e-mail nebyl potvrzen'**
  String get auth_error_email_not_confirmed;

  /// No description provided for @auth_error_account_blocked.
  ///
  /// In cs, this message translates to:
  /// **'Váš účet byl zablokován administrátorem'**
  String get auth_error_account_blocked;

  /// No description provided for @auth_error_not_authenticated.
  ///
  /// In cs, this message translates to:
  /// **'Pro změnu hesla se musíte přihlásit'**
  String get auth_error_not_authenticated;

  /// No description provided for @auth_error_invalid_current_password.
  ///
  /// In cs, this message translates to:
  /// **'Současné heslo není správné'**
  String get auth_error_invalid_current_password;

  /// No description provided for @auth_error_same_password.
  ///
  /// In cs, this message translates to:
  /// **'Nové heslo musí být odlišné od současného'**
  String get auth_error_same_password;

  /// No description provided for @auth_error_passwords_do_not_match.
  ///
  /// In cs, this message translates to:
  /// **'Hesla se neshodují'**
  String get auth_error_passwords_do_not_match;

  /// No description provided for @auth_error_incorrect_code.
  ///
  /// In cs, this message translates to:
  /// **'Neplatný nebo expirovaný kód'**
  String get auth_error_incorrect_code;

  /// No description provided for @auth_error_invalid_callback.
  ///
  /// In cs, this message translates to:
  /// **'Neplatná adresa pro návrat'**
  String get auth_error_invalid_callback;

  /// No description provided for @auth_error_registration_disabled.
  ///
  /// In cs, this message translates to:
  /// **'Registrace nových uživatelů není povolena'**
  String get auth_error_registration_disabled;

  /// No description provided for @auth_error_invalid_parameters.
  ///
  /// In cs, this message translates to:
  /// **'Neplatné parametry'**
  String get auth_error_invalid_parameters;

  /// No description provided for @auth_error_default_role_not_found.
  ///
  /// In cs, this message translates to:
  /// **'Výchozí role nebyla nalezena'**
  String get auth_error_default_role_not_found;

  /// No description provided for @auth_error_email_or_username_in_use.
  ///
  /// In cs, this message translates to:
  /// **'E-mail nebo uživatelské jméno jsou již používány'**
  String get auth_error_email_or_username_in_use;

  /// No description provided for @auth_error_email_send_error.
  ///
  /// In cs, this message translates to:
  /// **'Chyba při odesílání potvrzovacího e-mailu'**
  String get auth_error_email_send_error;

  /// No description provided for @auth_error_invalid_token.
  ///
  /// In cs, this message translates to:
  /// **'Neplatný potvrzovací token'**
  String get auth_error_invalid_token;

  /// No description provided for @auth_error_already_confirmed.
  ///
  /// In cs, this message translates to:
  /// **'Účet je již potvrzen'**
  String get auth_error_already_confirmed;

  /// No description provided for @auth_error_user_blocked.
  ///
  /// In cs, this message translates to:
  /// **'Uživatel je zablokován'**
  String get auth_error_user_blocked;

  /// No description provided for @auth_error_network_error.
  ///
  /// In cs, this message translates to:
  /// **'Chyba síťového připojení'**
  String get auth_error_network_error;

  /// No description provided for @auth_error_server_error.
  ///
  /// In cs, this message translates to:
  /// **'Chyba serveru'**
  String get auth_error_server_error;

  /// No description provided for @auth_error_unknown_error.
  ///
  /// In cs, this message translates to:
  /// **'Neočekávaná chyba'**
  String get auth_error_unknown_error;

  /// No description provided for @error_network.
  ///
  /// In cs, this message translates to:
  /// **'Problém s připojením k internetu. Zkontrolujte prosím vaše síťové připojení.'**
  String get error_network;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
