// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get bottom_nav_bar_item_map => 'Mapa';

  @override
  String get bottom_nav_bar_item_scanner => 'QR sken';

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
}
