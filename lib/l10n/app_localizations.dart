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

  /// No description provided for @error_widget_default_title.
  ///
  /// In cs, this message translates to:
  /// **'Něco se pokazilo'**
  String get error_widget_default_title;

  /// No description provided for @error_widget_default_subtitle.
  ///
  /// In cs, this message translates to:
  /// **'Zkuste to prosím znovu'**
  String get error_widget_default_subtitle;

  /// No description provided for @error_widget_default_try_again.
  ///
  /// In cs, this message translates to:
  /// **'Zkusit znovu'**
  String get error_widget_default_try_again;

  /// No description provided for @offline_placeholder_title.
  ///
  /// In cs, this message translates to:
  /// **'Jste offline'**
  String get offline_placeholder_title;

  /// No description provided for @offline_placeholder_message_offline.
  ///
  /// In cs, this message translates to:
  /// **'Nemáte připojení k internetu. Mapová data vyžadují online připojení.'**
  String get offline_placeholder_message_offline;

  /// No description provided for @error_connectivity_status_title.
  ///
  /// In cs, this message translates to:
  /// **'Chyba vyhodnocení stavu připojení'**
  String get error_connectivity_status_title;

  /// No description provided for @error_connectivity_status_subtitle.
  ///
  /// In cs, this message translates to:
  /// **'Zkuste to prosím znovu'**
  String get error_connectivity_status_subtitle;

  /// No description provided for @location_permission_denied.
  ///
  /// In cs, this message translates to:
  /// **'Bez přístupu k poloze nelze zobrazit vaši pozici na mapě.'**
  String get location_permission_denied;

  /// No description provided for @location_permission_denied_forever.
  ///
  /// In cs, this message translates to:
  /// **'Přístup k poloze je trvale zamítnut. Povolte jej v nastavení.'**
  String get location_permission_denied_forever;

  /// No description provided for @location_service_off.
  ///
  /// In cs, this message translates to:
  /// **'Služby určování polohy jsou vypnuté.'**
  String get location_service_off;

  /// No description provided for @location_action_settings.
  ///
  /// In cs, this message translates to:
  /// **'Nastavení'**
  String get location_action_settings;

  /// No description provided for @map_my_location.
  ///
  /// In cs, this message translates to:
  /// **'Moje poloha'**
  String get map_my_location;

  /// No description provided for @map_favorites.
  ///
  /// In cs, this message translates to:
  /// **'Moje studánky'**
  String get map_favorites;

  /// No description provided for @map_help.
  ///
  /// In cs, this message translates to:
  /// **'Nápověda'**
  String get map_help;

  /// No description provided for @map_potability_disclaimer_title.
  ///
  /// In cs, this message translates to:
  /// **'Tekoucí voda neznamená pitná voda'**
  String get map_potability_disclaimer_title;

  /// No description provided for @map_potability_disclaimer_semantic.
  ///
  /// In cs, this message translates to:
  /// **'Tekoucí voda neznamená pitná voda. Otevřít vysvětlení.'**
  String get map_potability_disclaimer_semantic;

  /// No description provided for @map_potability_disclaimer_body.
  ///
  /// In cs, this message translates to:
  /// **'Aplikace informuje pouze o tom, zda je ve studánce hlášený tok vody. Neověřuje zdravotní nezávadnost ani pitnost vody. Užívání vody je na vlastní odpovědnost.'**
  String get map_potability_disclaimer_body;

  /// No description provided for @map_potability_disclaimer_confirm.
  ///
  /// In cs, this message translates to:
  /// **'Rozumím'**
  String get map_potability_disclaimer_confirm;

  /// No description provided for @about_dialog_title.
  ///
  /// In cs, this message translates to:
  /// **'Studánky'**
  String get about_dialog_title;

  /// No description provided for @about_dialog_body.
  ///
  /// In cs, this message translates to:
  /// **'Aplikace na mapě ukazuje, zda ve studánce hlášeně teče voda a jak čerstvá je informace. Trasu si naplánujte ve své mapové aplikaci přes tlačítko Navigovat v detailu studánky.'**
  String get about_dialog_body;

  /// No description provided for @about_dialog_legend_title.
  ///
  /// In cs, this message translates to:
  /// **'Význam značek'**
  String get about_dialog_legend_title;

  /// No description provided for @about_dialog_legend_flowing.
  ///
  /// In cs, this message translates to:
  /// **'Teče voda'**
  String get about_dialog_legend_flowing;

  /// No description provided for @about_dialog_legend_not_flowing.
  ///
  /// In cs, this message translates to:
  /// **'Neteče voda'**
  String get about_dialog_legend_not_flowing;

  /// No description provided for @about_dialog_legend_stale.
  ///
  /// In cs, this message translates to:
  /// **'Neaktuální'**
  String get about_dialog_legend_stale;

  /// No description provided for @about_dialog_legend_unknown.
  ///
  /// In cs, this message translates to:
  /// **'Neznámý stav'**
  String get about_dialog_legend_unknown;

  /// No description provided for @map_search_hint.
  ///
  /// In cs, this message translates to:
  /// **'Hledejte studánky, obce, adresy…'**
  String get map_search_hint;

  /// No description provided for @map_search_error.
  ///
  /// In cs, this message translates to:
  /// **'Vyhledávání teď není dostupné.'**
  String get map_search_error;

  /// No description provided for @map_search_clear.
  ///
  /// In cs, this message translates to:
  /// **'Vymazat hledání'**
  String get map_search_clear;

  /// No description provided for @map_search_close.
  ///
  /// In cs, this message translates to:
  /// **'Zavřít vyhledávání'**
  String get map_search_close;

  /// No description provided for @map_search_type_spring.
  ///
  /// In cs, this message translates to:
  /// **'Studánka'**
  String get map_search_type_spring;

  /// No description provided for @map_search_type_country.
  ///
  /// In cs, this message translates to:
  /// **'Země'**
  String get map_search_type_country;

  /// No description provided for @map_search_type_region.
  ///
  /// In cs, this message translates to:
  /// **'Kraj / oblast'**
  String get map_search_type_region;

  /// No description provided for @map_search_type_municipality.
  ///
  /// In cs, this message translates to:
  /// **'Obec / město'**
  String get map_search_type_municipality;

  /// No description provided for @map_search_type_municipality_part.
  ///
  /// In cs, this message translates to:
  /// **'Část obce'**
  String get map_search_type_municipality_part;

  /// No description provided for @map_search_type_street.
  ///
  /// In cs, this message translates to:
  /// **'Ulice'**
  String get map_search_type_street;

  /// No description provided for @map_search_type_address.
  ///
  /// In cs, this message translates to:
  /// **'Adresa'**
  String get map_search_type_address;

  /// No description provided for @map_search_type_place.
  ///
  /// In cs, this message translates to:
  /// **'Místo'**
  String get map_search_type_place;

  /// No description provided for @map_search_type_coordinate.
  ///
  /// In cs, this message translates to:
  /// **'Souřadnice'**
  String get map_search_type_coordinate;

  /// No description provided for @map_empty_title.
  ///
  /// In cs, this message translates to:
  /// **'V této oblasti nejsou žádné studánky'**
  String get map_empty_title;

  /// No description provided for @map_empty_message.
  ///
  /// In cs, this message translates to:
  /// **'Posuňte mapu nebo oddalte zobrazení.'**
  String get map_empty_message;

  /// No description provided for @map_zoom_in.
  ///
  /// In cs, this message translates to:
  /// **'Přiblížit'**
  String get map_zoom_in;

  /// No description provided for @map_zoom_out.
  ///
  /// In cs, this message translates to:
  /// **'Oddálit'**
  String get map_zoom_out;

  /// No description provided for @map_status_stale.
  ///
  /// In cs, this message translates to:
  /// **'Neaktuální data'**
  String get map_status_stale;

  /// No description provided for @map_marker_semantic.
  ///
  /// In cs, this message translates to:
  /// **'Studánka {name}: {status}'**
  String map_marker_semantic(String name, String status);

  /// No description provided for @map_cluster_semantic.
  ///
  /// In cs, this message translates to:
  /// **'Shluk studánek, počet {count}'**
  String map_cluster_semantic(int count);

  /// No description provided for @favorites_sheet_title.
  ///
  /// In cs, this message translates to:
  /// **'Moje studánky'**
  String get favorites_sheet_title;

  /// No description provided for @favorites_empty_title.
  ///
  /// In cs, this message translates to:
  /// **'Zatím žádné uložené studánky'**
  String get favorites_empty_title;

  /// No description provided for @favorites_empty_message.
  ///
  /// In cs, this message translates to:
  /// **'Studánku si uložíte tlačítkem záložky v jejím detailu.'**
  String get favorites_empty_message;

  /// No description provided for @favorites_remove.
  ///
  /// In cs, this message translates to:
  /// **'Odebrat z mých studánek'**
  String get favorites_remove;

  /// No description provided for @qr_scan_camera_error.
  ///
  /// In cs, this message translates to:
  /// **'Kameru se nepodařilo otevřít. Zkontrolujte oprávnění a zkuste to znovu.'**
  String get qr_scan_camera_error;

  /// No description provided for @qr_scan_title.
  ///
  /// In cs, this message translates to:
  /// **'Naskenujte QR kód'**
  String get qr_scan_title;

  /// No description provided for @qr_scan_message.
  ///
  /// In cs, this message translates to:
  /// **'Zarovnejte kód do rámečku. Výsledek se zobrazí zde.'**
  String get qr_scan_message;

  /// No description provided for @qr_scan_detected_title.
  ///
  /// In cs, this message translates to:
  /// **'QR kód načten'**
  String get qr_scan_detected_title;

  /// No description provided for @qr_scan_again.
  ///
  /// In cs, this message translates to:
  /// **'Skenovat znovu'**
  String get qr_scan_again;

  /// No description provided for @qr_scan_processing.
  ///
  /// In cs, this message translates to:
  /// **'Zpracovávám…'**
  String get qr_scan_processing;

  /// No description provided for @qr_scan_failed.
  ///
  /// In cs, this message translates to:
  /// **'Skenování selhalo'**
  String get qr_scan_failed;

  /// No description provided for @qr_scan_try_again.
  ///
  /// In cs, this message translates to:
  /// **'Zkusit znovu'**
  String get qr_scan_try_again;

  /// No description provided for @qr_scan_invalid_data.
  ///
  /// In cs, this message translates to:
  /// **'QR kód neobsahuje platná data'**
  String get qr_scan_invalid_data;

  /// No description provided for @spring_detail_add_favorite.
  ///
  /// In cs, this message translates to:
  /// **'Přidat do mých studánek'**
  String get spring_detail_add_favorite;

  /// No description provided for @spring_detail_remove_favorite.
  ///
  /// In cs, this message translates to:
  /// **'Odebrat z mých studánek'**
  String get spring_detail_remove_favorite;

  /// No description provided for @common_yes.
  ///
  /// In cs, this message translates to:
  /// **'Ano'**
  String get common_yes;

  /// No description provided for @common_no.
  ///
  /// In cs, this message translates to:
  /// **'Ne'**
  String get common_no;

  /// No description provided for @spring_detail_status_flowing.
  ///
  /// In cs, this message translates to:
  /// **'Teče'**
  String get spring_detail_status_flowing;

  /// No description provided for @spring_detail_status_not_flowing.
  ///
  /// In cs, this message translates to:
  /// **'Neteče'**
  String get spring_detail_status_not_flowing;

  /// No description provided for @spring_detail_status_unknown.
  ///
  /// In cs, this message translates to:
  /// **'Neznámo'**
  String get spring_detail_status_unknown;

  /// No description provided for @spring_detail_section_current.
  ///
  /// In cs, this message translates to:
  /// **'Současný stav'**
  String get spring_detail_section_current;

  /// No description provided for @spring_detail_section_last_known.
  ///
  /// In cs, this message translates to:
  /// **'Poslední známý stav'**
  String get spring_detail_section_last_known;

  /// No description provided for @spring_detail_section_about.
  ///
  /// In cs, this message translates to:
  /// **'O studánce'**
  String get spring_detail_section_about;

  /// No description provided for @spring_detail_no_record_yet.
  ///
  /// In cs, this message translates to:
  /// **'zatím bez záznamu'**
  String get spring_detail_no_record_yet;

  /// No description provided for @spring_detail_action_share.
  ///
  /// In cs, this message translates to:
  /// **'Sdílet'**
  String get spring_detail_action_share;

  /// No description provided for @spring_detail_action_navigate.
  ///
  /// In cs, this message translates to:
  /// **'Navigovat'**
  String get spring_detail_action_navigate;

  /// No description provided for @spring_detail_coordinates_copied.
  ///
  /// In cs, this message translates to:
  /// **'Souřadnice zkopírovány'**
  String get spring_detail_coordinates_copied;

  /// No description provided for @spring_detail_navigation_failed.
  ///
  /// In cs, this message translates to:
  /// **'Nepodařilo se otevřít mapu'**
  String get spring_detail_navigation_failed;

  /// No description provided for @spring_detail_open_in_app.
  ///
  /// In cs, this message translates to:
  /// **'Otevřít v aplikaci'**
  String get spring_detail_open_in_app;

  /// No description provided for @spring_detail_share_text.
  ///
  /// In cs, this message translates to:
  /// **'{name}\n{coordinates}\n{url}'**
  String spring_detail_share_text(String name, String coordinates, String url);

  /// No description provided for @spring_detail_load_error.
  ///
  /// In cs, this message translates to:
  /// **'Detail studánky se nepodařilo načíst'**
  String get spring_detail_load_error;

  /// No description provided for @spring_detail_history_title.
  ///
  /// In cs, this message translates to:
  /// **'Historie záznamů'**
  String get spring_detail_history_title;

  /// No description provided for @spring_detail_history_empty.
  ///
  /// In cs, this message translates to:
  /// **'Zatím žádné záznamy'**
  String get spring_detail_history_empty;

  /// No description provided for @spring_detail_history_error.
  ///
  /// In cs, this message translates to:
  /// **'Záznamy se nepodařilo načíst'**
  String get spring_detail_history_error;

  /// No description provided for @spring_detail_history_load_more_error.
  ///
  /// In cs, this message translates to:
  /// **'Další záznamy se nepodařilo načíst'**
  String get spring_detail_history_load_more_error;

  /// No description provided for @spring_detail_report_flow_rate.
  ///
  /// In cs, this message translates to:
  /// **'Průtok'**
  String get spring_detail_report_flow_rate;

  /// No description provided for @spring_detail_report_flow_strength.
  ///
  /// In cs, this message translates to:
  /// **'Síla pramene'**
  String get spring_detail_report_flow_strength;

  /// No description provided for @spring_detail_report_clarity.
  ///
  /// In cs, this message translates to:
  /// **'Čistota'**
  String get spring_detail_report_clarity;

  /// No description provided for @spring_detail_report_odor.
  ///
  /// In cs, this message translates to:
  /// **'Zápach'**
  String get spring_detail_report_odor;

  /// No description provided for @spring_detail_report_note.
  ///
  /// In cs, this message translates to:
  /// **'Poznámka'**
  String get spring_detail_report_note;

  /// No description provided for @spring_detail_station_record.
  ///
  /// In cs, this message translates to:
  /// **'ČHMÚ'**
  String get spring_detail_station_record;

  /// No description provided for @spring_detail_flow_rate_value.
  ///
  /// In cs, this message translates to:
  /// **'{value} l/s'**
  String spring_detail_flow_rate_value(String value);

  /// No description provided for @water_clarity_crystal_clear.
  ///
  /// In cs, this message translates to:
  /// **'Křišťálově čirá'**
  String get water_clarity_crystal_clear;

  /// No description provided for @water_clarity_clear.
  ///
  /// In cs, this message translates to:
  /// **'Čirá'**
  String get water_clarity_clear;

  /// No description provided for @water_clarity_slightly_turbid.
  ///
  /// In cs, this message translates to:
  /// **'Mírně zakalená'**
  String get water_clarity_slightly_turbid;

  /// No description provided for @water_clarity_turbid.
  ///
  /// In cs, this message translates to:
  /// **'Zakalená'**
  String get water_clarity_turbid;

  /// No description provided for @water_clarity_heavily_turbid.
  ///
  /// In cs, this message translates to:
  /// **'Silně zakalená'**
  String get water_clarity_heavily_turbid;

  /// No description provided for @age_just_now.
  ///
  /// In cs, this message translates to:
  /// **'právě teď'**
  String get age_just_now;

  /// No description provided for @age_minutes.
  ///
  /// In cs, this message translates to:
  /// **'{count, plural, one{před {count} minutou} few{před {count} minutami} other{před {count} minutami}}'**
  String age_minutes(int count);

  /// No description provided for @age_hours.
  ///
  /// In cs, this message translates to:
  /// **'{count, plural, one{před {count} hodinou} few{před {count} hodinami} other{před {count} hodinami}}'**
  String age_hours(int count);

  /// No description provided for @age_days.
  ///
  /// In cs, this message translates to:
  /// **'{count, plural, one{před {count} dnem} few{před {count} dny} other{před {count} dny}}'**
  String age_days(int count);
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
