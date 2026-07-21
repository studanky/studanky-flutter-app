import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:studanky_flutter_app/core/env.dart';

class ApiConfig {
  /// Backend base URL, configured per environment via `--dart-define`.
  static String get baseUrl => Env.baseUrl;

  // Strapi endpoints
  static const String authEndpoint = '/auth/local';
  static const String registerEndpoint = '/auth/local/register';
  static const String generatePasswordEndpoint = '/auth/generate-password';
  static const String changePasswordEndpoint = '/auth/change-password';
  static const String sendEmailConfirmationEndpoint =
      '/auth/send-email-confirmation';
  static const String meEndpoint = '/users/me';
  static const String userProfileByUserEndpoint = '/user-profile/user';
  static String cowshedsBulkEndpoint(String documentIds) =>
      'cowsheds/bulk/$documentIds';

  /// Example Feature
  static const String exampleItemsEndpoint = '/example-items';

  /// Platform config single type (dynamic freshness threshold + flow scale).
  static const String platformConfigEndpoint = '/platform-config';

  /// Spring collection root. Detail is `/springs/{documentId}` and its report
  /// history `/springs/{documentId}/reports` (api-reference.md §3.2–3.3).
  static const String springsEndpoint = '/springs';

  /// Minimal spring marker payload for the map, filtered by `bbox`.
  static const String springsMapEndpoint = '/springs/map';

  /// Name autocomplete for map search; returns the same map-safe marker fields.
  static const String springsSearchEndpoint = '/springs/search';

  /// Report history page size (server clamps to 1–100; api-reference.md §3.3).
  static const int reportsPageSize = 20;

  // Timeouts optimized for mobile
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  // Storage keys
  static const String credentialsEmailKey = 'strapi_credentials_email';
  static const String credentialsPasswordKey = 'strapi_credentials_password';
  static const String userKey = 'strapi_user';

  // Secure storage configuration
  static const String secureStorageAndroidSharedPreferencesName =
      'studanky_secure_prefs';
  static const String secureStorageAndroidPreferencesKeyPrefix = 'studanky_';
  static const String secureStorageIosAccountName =
      'cz.studankyapp.studanky.secure';
  static const KeychainAccessibility secureStorageIosAccessibility =
      KeychainAccessibility.first_unlock_this_device;
  static const bool secureStorageIosSynchronizable = true;

  // Default headers for Strapi v5.17.0
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  // Authenticated headers
  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  // Query parameters for Strapi v5 population
  static Map<String, dynamic> get defaultPopulateParams => {'populate': '*'};

  // Pagination parameters
  static Map<String, dynamic> paginationParams({
    int page = 1,
    int pageSize = 25,
    String? sort,
    Map<String, dynamic>? filters,
  }) => {
    'pagination[page]': page,
    'pagination[pageSize]': pageSize,
    'sort': ?sort,
    ...?filters,
  };
}
