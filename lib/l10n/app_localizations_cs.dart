// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get auth_error_provider_disabled =>
      'Tento způsob přihlášení není povolen';

  @override
  String get auth_error_invalid_credentials => 'Neplatné přihlašovací údaje';

  @override
  String get auth_error_email_not_confirmed => 'Váš e-mail nebyl potvrzen';

  @override
  String get auth_error_account_blocked =>
      'Váš účet byl zablokován administrátorem';

  @override
  String get auth_error_not_authenticated =>
      'Pro změnu hesla se musíte přihlásit';

  @override
  String get auth_error_invalid_current_password =>
      'Současné heslo není správné';

  @override
  String get auth_error_same_password =>
      'Nové heslo musí být odlišné od současného';

  @override
  String get auth_error_passwords_do_not_match => 'Hesla se neshodují';

  @override
  String get auth_error_incorrect_code => 'Neplatný nebo expirovaný kód';

  @override
  String get auth_error_invalid_callback => 'Neplatná adresa pro návrat';

  @override
  String get auth_error_registration_disabled =>
      'Registrace nových uživatelů není povolena';

  @override
  String get auth_error_invalid_parameters => 'Neplatné parametry';

  @override
  String get auth_error_default_role_not_found =>
      'Výchozí role nebyla nalezena';

  @override
  String get auth_error_email_or_username_in_use =>
      'E-mail nebo uživatelské jméno jsou již používány';

  @override
  String get auth_error_email_send_error =>
      'Chyba při odesílání potvrzovacího e-mailu';

  @override
  String get auth_error_invalid_token => 'Neplatný potvrzovací token';

  @override
  String get auth_error_already_confirmed => 'Účet je již potvrzen';

  @override
  String get auth_error_user_blocked => 'Uživatel je zablokován';

  @override
  String get auth_error_network_error => 'Chyba síťového připojení';

  @override
  String get auth_error_server_error => 'Chyba serveru';

  @override
  String get auth_error_unknown_error => 'Neočekávaná chyba';

  @override
  String get error_network =>
      'Problém s připojením k internetu. Zkontrolujte prosím vaše síťové připojení.';

  @override
  String get error_widget_default_title => 'Něco se pokazilo';

  @override
  String get error_widget_default_subtitle => 'Zkuste to prosím znovu';

  @override
  String get error_widget_default_try_again => 'Zkusit znovu';

  @override
  String get offline_placeholder_title => 'Jste offline';

  @override
  String get offline_placeholder_message_offline =>
      'Nemáte připojení k internetu. Mapová data vyžadují online připojení.';

  @override
  String get error_connectivity_status_title =>
      'Chyba vyhodnocení stavu připojení';

  @override
  String get error_connectivity_status_subtitle => 'Zkuste to prosím znovu';

  @override
  String get location_permission_denied =>
      'Bez přístupu k poloze nelze zobrazit vaši pozici na mapě.';

  @override
  String get location_permission_denied_forever =>
      'Přístup k poloze je trvale zamítnut. Povolte jej v nastavení.';

  @override
  String get location_service_off => 'Služby určování polohy jsou vypnuté.';

  @override
  String get location_action_settings => 'Nastavení';

  @override
  String get map_my_location => 'Moje poloha';

  @override
  String get map_favorites => 'Oblíbené studánky';

  @override
  String get map_help => 'Nápověda';

  @override
  String get map_search_hint => 'Hledejte studánky, obce, adresy…';

  @override
  String get map_search_error => 'Vyhledávání teď není dostupné.';

  @override
  String get map_empty_title => 'V této oblasti nejsou žádné studánky';

  @override
  String get map_empty_message => 'Posuňte mapu nebo oddalte zobrazení.';

  @override
  String get map_zoom_in => 'Přiblížit';

  @override
  String get map_zoom_out => 'Oddálit';

  @override
  String get map_status_stale => 'Neaktuální data';

  @override
  String map_marker_semantic(String name, String status) {
    return 'Studánka $name: $status';
  }

  @override
  String map_cluster_semantic(int count) {
    return 'Shluk studánek, počet $count';
  }

  @override
  String get favorites_sheet_title => 'Oblíbené studánky';

  @override
  String get favorites_empty_title => 'Zatím žádné oblíbené';

  @override
  String get favorites_empty_message =>
      'Studánku přidáte do oblíbených tlačítkem v jejím detailu.';

  @override
  String get favorites_remove => 'Odebrat z oblíbených';

  @override
  String get spring_detail_add_favorite => 'Přidat do oblíbených';

  @override
  String get spring_detail_remove_favorite => 'Odebrat z oblíbených';

  @override
  String get common_yes => 'Ano';

  @override
  String get common_no => 'Ne';

  @override
  String get spring_detail_status_flowing => 'Teče';

  @override
  String get spring_detail_status_not_flowing => 'Neteče';

  @override
  String get spring_detail_status_unknown => 'Neznámo';

  @override
  String get spring_detail_section_current => 'Současný stav';

  @override
  String get spring_detail_section_last_known => 'Poslední známý stav';

  @override
  String get spring_detail_section_about => 'O studánce';

  @override
  String get spring_detail_no_record_yet => 'zatím bez záznamu';

  @override
  String get spring_detail_action_share => 'Sdílet';

  @override
  String get spring_detail_action_navigate => 'Navigovat';

  @override
  String get spring_detail_coordinates_copied => 'Souřadnice zkopírovány';

  @override
  String get spring_detail_navigation_failed =>
      'Nepodařilo se otevřít navigaci';

  @override
  String spring_detail_share_text(String name, String coordinates, String url) {
    return '$name\n$coordinates\n$url';
  }

  @override
  String get spring_detail_load_error => 'Detail studánky se nepodařilo načíst';

  @override
  String get spring_detail_history_title => 'Historie záznamů';

  @override
  String get spring_detail_history_empty => 'Zatím žádné záznamy';

  @override
  String get spring_detail_history_error => 'Záznamy se nepodařilo načíst';

  @override
  String get spring_detail_history_load_more_error =>
      'Další záznamy se nepodařilo načíst';

  @override
  String get spring_detail_report_flow_rate => 'Průtok';

  @override
  String get spring_detail_report_flow_strength => 'Síla pramene';

  @override
  String get spring_detail_report_clarity => 'Čistota';

  @override
  String get spring_detail_report_odor => 'Zápach';

  @override
  String get spring_detail_report_note => 'Poznámka';

  @override
  String get spring_detail_station_record => 'ČHMÚ';

  @override
  String spring_detail_flow_rate_value(String value) {
    return '$value l/s';
  }

  @override
  String get water_clarity_crystal_clear => 'Křišťálově čirá';

  @override
  String get water_clarity_clear => 'Čirá';

  @override
  String get water_clarity_slightly_turbid => 'Mírně zakalená';

  @override
  String get water_clarity_turbid => 'Zakalená';

  @override
  String get water_clarity_heavily_turbid => 'Silně zakalená';

  @override
  String get age_just_now => 'právě teď';

  @override
  String age_minutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'před $count minutami',
      few: 'před $count minutami',
      one: 'před $count minutou',
    );
    return '$_temp0';
  }

  @override
  String age_hours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'před $count hodinami',
      few: 'před $count hodinami',
      one: 'před $count hodinou',
    );
    return '$_temp0';
  }

  @override
  String age_days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'před $count dny',
      few: 'před $count dny',
      one: 'před $count dnem',
    );
    return '$_temp0';
  }
}
