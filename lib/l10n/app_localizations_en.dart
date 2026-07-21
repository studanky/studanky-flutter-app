// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get auth_error_provider_disabled =>
      'This sign-in method is not enabled';

  @override
  String get auth_error_invalid_credentials => 'Invalid sign-in details';

  @override
  String get auth_error_email_not_confirmed =>
      'Your email has not been confirmed';

  @override
  String get auth_error_account_blocked =>
      'Your account has been blocked by an administrator';

  @override
  String get auth_error_not_authenticated =>
      'You must sign in to change your password';

  @override
  String get auth_error_invalid_current_password =>
      'The current password is not correct';

  @override
  String get auth_error_same_password =>
      'The new password must be different from the current one';

  @override
  String get auth_error_passwords_do_not_match => 'Passwords do not match';

  @override
  String get auth_error_incorrect_code => 'Invalid or expired code';

  @override
  String get auth_error_invalid_callback => 'Invalid return address';

  @override
  String get auth_error_registration_disabled =>
      'New user registration is not enabled';

  @override
  String get auth_error_invalid_parameters => 'Invalid parameters';

  @override
  String get auth_error_default_role_not_found => 'Default role was not found';

  @override
  String get auth_error_email_or_username_in_use =>
      'Email or username is already in use';

  @override
  String get auth_error_email_send_error =>
      'Could not send the confirmation email';

  @override
  String get auth_error_invalid_token => 'Invalid confirmation token';

  @override
  String get auth_error_already_confirmed => 'The account is already confirmed';

  @override
  String get auth_error_user_blocked => 'The user is blocked';

  @override
  String get auth_error_network_error => 'Network connection error';

  @override
  String get auth_error_server_error => 'Server error';

  @override
  String get auth_error_unknown_error => 'Unexpected error';

  @override
  String get error_network =>
      'There is a problem with your internet connection. Please check your network connection.';

  @override
  String get error_widget_default_title => 'Something went wrong';

  @override
  String get error_widget_default_subtitle => 'Please try again';

  @override
  String get error_widget_default_try_again => 'Try again';

  @override
  String get offline_banner_title => 'You are offline';

  @override
  String get offline_banner_message => 'Map data may not load completely.';

  @override
  String get location_permission_denied =>
      'Without location access, the app cannot show your position on the map.';

  @override
  String get location_permission_denied_forever =>
      'Location access is permanently denied. Enable it in Settings.';

  @override
  String get location_service_off => 'Location services are turned off.';

  @override
  String get location_action_settings => 'Settings';

  @override
  String get map_my_location => 'My location';

  @override
  String get map_favorites => 'My springs';

  @override
  String get map_help => 'Help';

  @override
  String get map_potability_disclaimer_title =>
      'Flowing water does not mean drinking water';

  @override
  String get map_potability_disclaimer_semantic =>
      'Flowing water does not mean drinking water. Open explanation.';

  @override
  String get map_potability_disclaimer_body =>
      'The app only shows whether water flow has been reported at a spring. It does not verify health safety or whether the water is drinkable. Use water at your own risk.';

  @override
  String get map_potability_disclaimer_confirm => 'I understand';

  @override
  String get about_dialog_title => 'Studánky';

  @override
  String get about_dialog_body =>
      'Studánky is a community map of places in nature where people share whether water is flowing. It helps plan trips based on the freshness of reports, carry less water and reduce single-use bottles in nature. You can plan your route in your map app using the Navigate button in a spring detail.';

  @override
  String get about_dialog_more_info_link => 'More information on the website';

  @override
  String get about_dialog_legend_title => 'Marker legend';

  @override
  String get about_dialog_legend_flowing => 'Water is flowing';

  @override
  String get about_dialog_legend_not_flowing => 'Water is not flowing';

  @override
  String get about_dialog_legend_stale => 'Outdated';

  @override
  String get about_dialog_legend_unknown => 'Unknown status';

  @override
  String get about_project_title => 'About the app';

  @override
  String get legal_link_terms => 'Terms of use';

  @override
  String get legal_link_privacy => 'Privacy policy';

  @override
  String get legal_link_data_sources => 'Data sources';

  @override
  String get legal_link_contact => 'Contact';

  @override
  String get legal_onboarding_title => 'Welcome to Studánky';

  @override
  String get legal_onboarding_back => 'Back';

  @override
  String get legal_onboarding_next => 'Continue';

  @override
  String get legal_onboarding_finish => 'Go to map';

  @override
  String get legal_onboarding_step_welcome_title => 'Springs on nature trips';

  @override
  String get legal_onboarding_step_welcome_body =>
      'Studánky is a community project built by people for people. It helps you see where water flow has been reported so you can plan your trip with more respect for nature.';

  @override
  String get legal_onboarding_step_welcome_bullet_community =>
      'Carry less water on your back and fewer single-use bottles in your backpack and in nature.';

  @override
  String get legal_onboarding_step_welcome_bullet_feedback =>
      'If you find a mistake or have an idea, we will appreciate your feedback.';

  @override
  String get legal_onboarding_step_water_title =>
      'Flowing water may not be drinkable';

  @override
  String get legal_onboarding_step_water_body =>
      'Studánky mainly shows whether water flow has been reported at a source. We do not verify quality, drinkability or health safety.';

  @override
  String get legal_onboarding_step_water_bullet_flow =>
      'Flowing water is not confirmation that it is safe to drink.';

  @override
  String get legal_onboarding_step_water_bullet_marked =>
      'Even a marked spring may not have currently verified drinkability.';

  @override
  String get legal_onboarding_step_water_bullet_quality =>
      'Unless a source is explicitly and currently marked as drinkable, treat the water as risky.';

  @override
  String get about_legal_info_title => 'App and operator';

  @override
  String get about_legal_version_label => 'Version';

  @override
  String get about_legal_version_loading => 'loading';

  @override
  String get about_legal_data_title => 'Data sources';

  @override
  String get about_legal_chmu_body =>
      'Data on spring yield comes from open data of the Czech Hydrometeorological Institute (CHMI) under the Creative Commons BY 4.0 license. The data has been adapted and interpreted into flowing / not flowing states for the app. CHMI does not operate, endorse or sponsor the app.';

  @override
  String get about_legal_cc_by_link => 'Creative Commons BY 4.0 license';

  @override
  String get about_legal_mapy_body =>
      'Map data and map services are provided by Seznam.cz, a.s. through Mapy.com.';

  @override
  String get about_legal_mapy_link => 'Mapy.com copyright and attribution';

  @override
  String get about_legal_privacy_title => 'Privacy';

  @override
  String get about_legal_privacy_body =>
      'The app does not require an account and does not use ads, analytics or tracking. Location is used to show your position on the map, place and address search uses Mapy.com/Seznam.cz, and My springs are stored locally on the device.';

  @override
  String get about_legal_documents_title => 'More information';

  @override
  String get about_legal_documents_body =>
      'Legal information, privacy details, contact and complete data sources are available on the website.';

  @override
  String get about_legal_open_source_licenses => 'Open-source licenses';

  @override
  String about_legal_version_line(String version) {
    return 'App version $version';
  }

  @override
  String get map_search_hint => 'Search springs, towns, addresses...';

  @override
  String get map_search_error => 'Search is not available right now.';

  @override
  String get map_search_clear => 'Clear search';

  @override
  String get map_search_close => 'Close search';

  @override
  String get map_search_type_spring => 'Spring';

  @override
  String get map_search_type_country => 'Country';

  @override
  String get map_search_type_region => 'Region / area';

  @override
  String get map_search_type_municipality => 'Town / municipality';

  @override
  String get map_search_type_municipality_part => 'Part of municipality';

  @override
  String get map_search_type_street => 'Street';

  @override
  String get map_search_type_address => 'Address';

  @override
  String get map_search_type_place => 'Place';

  @override
  String get map_search_type_coordinate => 'Coordinates';

  @override
  String get map_empty_title => 'There are no springs in this area';

  @override
  String get map_empty_message => 'Move the map or zoom out.';

  @override
  String get map_zoom_in => 'Zoom in';

  @override
  String get map_zoom_out => 'Zoom out';

  @override
  String get map_status_stale => 'Outdated data';

  @override
  String map_marker_semantic(String name, String status) {
    return 'Spring $name: $status';
  }

  @override
  String map_cluster_semantic(int count) {
    return 'Spring cluster, count $count';
  }

  @override
  String get favorites_sheet_title => 'My springs';

  @override
  String get favorites_empty_title => 'No saved springs yet';

  @override
  String get favorites_empty_message =>
      'Save a spring using the bookmark button in its detail.';

  @override
  String get favorites_remove => 'Remove from my springs';

  @override
  String get spring_detail_add_favorite => 'Add to my springs';

  @override
  String get spring_detail_remove_favorite => 'Remove from my springs';

  @override
  String get common_yes => 'Yes';

  @override
  String get common_no => 'No';

  @override
  String get spring_detail_status_flowing => 'Flowing';

  @override
  String get spring_detail_status_not_flowing => 'Not flowing';

  @override
  String get spring_detail_status_unknown => 'Unknown';

  @override
  String get spring_detail_section_current => 'Current status';

  @override
  String get spring_detail_section_last_known => 'Last known status';

  @override
  String get spring_detail_section_about => 'About this spring';

  @override
  String get spring_detail_no_record_yet => 'no record yet';

  @override
  String get spring_detail_action_share => 'Share';

  @override
  String get spring_detail_action_navigate => 'Navigate';

  @override
  String get spring_detail_coordinates_copied => 'Coordinates copied';

  @override
  String get spring_detail_navigation_failed => 'Could not open the map';

  @override
  String get spring_detail_open_in_app => 'Open in app';

  @override
  String spring_detail_share_text(String name, String coordinates, String url) {
    return '$name\n$coordinates\n$url';
  }

  @override
  String get spring_detail_load_error => 'Could not load spring detail';

  @override
  String get spring_detail_history_title => 'Report history';

  @override
  String get spring_detail_history_empty => 'No reports yet';

  @override
  String get spring_detail_history_error => 'Could not load reports';

  @override
  String get spring_detail_history_load_more_error =>
      'Could not load more reports';

  @override
  String get spring_detail_report_flow_rate => 'Flow rate';

  @override
  String get spring_detail_report_flow_strength => 'Spring strength';

  @override
  String get spring_detail_report_clarity => 'Clarity';

  @override
  String get spring_detail_report_odor => 'Odor';

  @override
  String get spring_detail_report_note => 'Note';

  @override
  String get spring_detail_station_record => 'CHMI';

  @override
  String spring_detail_flow_rate_value(String value) {
    return '$value l/s';
  }

  @override
  String get water_clarity_crystal_clear => 'Crystal clear';

  @override
  String get water_clarity_clear => 'Clear';

  @override
  String get water_clarity_slightly_turbid => 'Slightly turbid';

  @override
  String get water_clarity_turbid => 'Turbid';

  @override
  String get water_clarity_heavily_turbid => 'Heavily turbid';

  @override
  String get age_just_now => 'just now';

  @override
  String age_minutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '$count minute ago',
    );
    return '$_temp0';
  }

  @override
  String age_hours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '$count hour ago',
    );
    return '$_temp0';
  }

  @override
  String age_days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '$count day ago',
    );
    return '$_temp0';
  }
}
