import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiConfig {
  // Use environment variables for different environments
  static const String baseUrl = 'http://localhost:1337/api';

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
      'ersta_secure_prefs';
  static const String secureStorageAndroidPreferencesKeyPrefix = 'ersta_';
  static const String secureStorageIosAccountName = 'cz.microcomp.ersta.secure';
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
    if (sort != null) 'sort': sort,
    if (filters != null) ...filters,
  };
}
