# 🔒 Secure Strapi API Client v5.17.0

Comprehensive and secure API communication layer for Flutter applications with **Strapi CMS v5.17.0**. This library provides a complete authentication and data management solution with modern Flutter patterns including Riverpod state management, Freezed data classes, and secure credential storage.

## ✨ Key Features

- **🔐 Secure Credential Storage** - User credentials stored securely using `flutter_secure_storage` with platform-specific encryption (iOS Keychain, Android Keystore)
- **🏗️ Type-Safe Models** - All data models use `@JsonSerializable` and `@freezed` for compile-time safety and immutable data structures
- **🌐 HTTP Client** - Dio-based HTTP client with automatic authentication interceptors and comprehensive logging
- **⚡ Asynchronous Operations** - Fully async API with proper error handling and cancellation support
- **🔄 Automatic Re-authentication** - Seamless token refresh and credential-based re-authentication on session expiry
- **🛡️ Comprehensive Error Handling** - Typed exceptions with detailed Strapi v5 error mapping and localization support
- **📧 Email Verification Flow** - Complete email confirmation workflow with automatic resend capabilities
- **📱 Cross-platform Support** - Native iOS Keychain and Android Keystore integration
- **🚀 Environment Configuration** - Support for multiple environments (development, staging, production)
- **📊 Strapi v5 Compatibility** - Full support for collections, single types, population, filtering, pagination, and file upload
- **🎯 State Management** - Integrated with Riverpod for reactive state management
- **🌍 Localization** - Comprehensive error message localization with fallback support

## 📁 Architecture & Structure

The API library follows a layered architecture pattern with clear separation of concerns:

```text
lib/src/core/api/
├── clients/
│   └── api_client.dart          # Core HTTP client with Dio + Strapi v5 optimized methods
├── config/
│   └── api_config.dart          # Centralized API configuration & environment settings
├── exceptions/
│   └── api_exceptions.dart      # Comprehensive typed exceptions with Strapi v5 error handling
├── interceptors/
│   ├── auth_interceptor.dart    # JWT token injection & automatic refresh handling
│   └── logging_interceptor.dart # Development & debugging request/response logging
├── models/
│   ├── auth_models.dart         # Authentication models (Login, Register, User, etc.)
│   └── api_response.dart        # Generic API response wrapper with metadata & pagination
├── services/
│   ├── auth_service.dart        # Authentication service with Freezed state management
│   └── base_api_service.dart    # Base CRUD operations + search functionality for Strapi v5
└── utils/
    ├── api_result.dart          # Functional result wrapper for safe error handling
    └── error_mapper.dart        # Comprehensive error message localization & mapping
```

### Core Components

1. **ApiClient** (`clients/api_client.dart`)
   - Primary HTTP client built on Dio
   - Strapi v5 optimized methods for collections and single types
   - Built-in population and query parameter handling
   - Automatic error handling and exception conversion

2. **AuthService** (`services/auth_service.dart`)
   - Freezed-based state management for authentication
   - Secure credential storage and automatic re-authentication
   - Email verification workflow support
   - JWT token management in memory only

3. **BaseApiService** (`services/base_api_service.dart`)
   - Generic CRUD operations for any Strapi collection
   - Advanced search and filtering capabilities
   - Pagination and metadata handling
   - Type-safe data transformation

4. **Exception Hierarchy** (`exceptions/api_exceptions.dart`)
   - Comprehensive typed exceptions for different error scenarios
   - Automatic Dio exception to API exception conversion
   - Strapi-specific error detail extraction

## 🚀 Getting Started

### 1. Environment Configuration

The API client supports multiple environments through compile-time configuration:

```dart
// Development (default)
flutter run --dart-define=API_BASE_URL=http://localhost:1337/api

// Staging
flutter run --dart-define=API_BASE_URL=https://staging-api.yourapp.com/api

// Production
flutter build apk --dart-define=API_BASE_URL=https://api.yourapp.com/api
```

### 2. Setup & Initialization

The API library uses Riverpod providers for dependency injection and state management:

```dart
// In your main.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// In your widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access authentication state
    final authState = ref.watch(authServiceProvider);
    final authService = ref.read(authServiceProvider.notifier);
    
    // Access API client
    final apiClient = ref.read(apiClientProvider);
    
    // Access generic API service
    final baseService = ref.read(genericApiServiceProvider);
    
    return YourWidget();
  }
}
```

### 3. Authentication Flow

The authentication system provides comprehensive user management with automatic credential storage and email verification:

```dart
final authService = ref.read(authServiceProvider.notifier);
final authState = ref.watch(authServiceProvider);

// User Registration
try {
  final registerResponse = await authService.register(RegisterRequest(
    username: 'johndoe',
    email: 'john@example.com',
    password: 'securePassword123',
  ));
  
  // Check if email verification is required
  if (registerResponse.jwt == null) {
    // User needs to verify email - credentials are stored securely
    print('Please check your email for verification link');
  } else {
    // User is immediately logged in (email verification disabled)
    print('Registration successful: ${registerResponse.user.username}');
  }
} on ValidationException catch (e) {
  print('Registration error: ${e.message}');
}

// User Login
try {
  final loginResponse = await authService.login(LoginRequest(
    identifier: 'john@example.com', // Can be email or username
    password: 'securePassword123',
  ));
  
  print('Logged in as: ${loginResponse.user.username}');
  print('Email verified: ${authState.isEmailVerified}');
} on ValidationException catch (e) {
  // If email is not confirmed, Strapi will automatically send confirmation email
  print('Login error: ${e.message}');
} on AuthenticationException catch (e) {
  print('Invalid credentials: ${e.message}');
}

// Authentication State Management
if (authState.isAuthenticationCompleted) {
  // User is fully authenticated (logged in + email verified)
  print('User is fully authenticated');
  navigateToHomeScreen();
} else if (authState.isUserAuthenticated && !authState.isEmailVerified) {
  // User logged in but needs email verification
  print('Please verify your email');
  showEmailVerificationScreen();
  
  // Optionally resend verification email
  await authService.sendEmailConfirmation(
    SendEmailConfirmationRequest(email: authState.user!.email)
  );
} else {
  // User not logged in
  showLoginScreen();
}

// Automatic Re-authentication
// The service automatically tries to re-authenticate using stored credentials
try {
  await authService.reAuthenticate();
  print('Re-authentication successful');
} catch (e) {
  print('Re-authentication failed, user needs to login again');
  showLoginScreen();
}

// Password Management
try {
  await authService.changePassword(ChangePasswordRequest(
    currentPassword: 'oldPassword',
    password: 'newSecurePassword123',
    passwordConfirmation: 'newSecurePassword123',
  ));
  print('Password changed successfully');
} on ValidationException catch (e) {
  print('Password change error: ${e.message}');
}

// User Profile
try {
  final currentUser = await authService.getCurrentUser();
  print('Current user: ${currentUser.username}');
  print('Email confirmed: ${currentUser.confirmed}');
} catch (e) {
  print('Failed to fetch user profile');
}

// Logout
await authService.logout();
print('User logged out successfully');
```

### 4. Strapi v5 Data Operations

#### Collections and Single Types

```dart
final apiClient = ref.read(apiClientProvider);

// Get collection with automatic population
final articlesResponse = await apiClient.getCollection<Map<String, dynamic>>(
  'articles',
  populate: true, // Automatically populates all relations
  queryParameters: ApiConfig.paginationParams(
    page: 1, 
    pageSize: 10,
    sort: 'publishedAt:desc',
  ),
);

// Get single type (e.g., global content)
final homePageData = await apiClient.getSingleType<Map<String, dynamic>>(
  'home-page',
  populate: true,
  queryParameters: {
    'populate[hero][populate]': '*', // Deep population
    'populate[sections][populate]': '*',
  },
);

// Get single item from collection
final singleArticle = await apiClient.get<Map<String, dynamic>>(
  '/articles/123',
  queryParameters: {
    'populate': '*',
  },
);
```

### 5. Advanced CRUD Operations with Type Safety

```dart
final baseService = ref.read(genericApiServiceProvider);

// Define your data model
class Article {
  final int id;
  final String title;
  final String content;
  final DateTime? publishedAt;
  final List<String> tags;
  final Author? author; // Populated relation
  
  Article({required this.id, required this.title, required this.content, 
          this.publishedAt, this.tags = const [], this.author});
  
  factory Article.fromJson(Map<String, dynamic> json) => Article(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    publishedAt: json['publishedAt'] != null 
        ? DateTime.parse(json['publishedAt']) : null,
    tags: List<String>.from(json['tags'] ?? []),
    author: json['author'] != null ? Author.fromJson(json['author']) : null,
  );
}

// Get paginated list with metadata
final articlesWithMeta = await baseService.getListWithMeta<Article>(
  'articles',
  page: 1,
  pageSize: 10,
  sort: 'publishedAt:desc',
  populate: true,
  fromJson: Article.fromJson,
);

print('Total articles: ${articlesWithMeta.meta?.pagination?.total}');
print('Current page: ${articlesWithMeta.meta?.pagination?.page}');
print('Page count: ${articlesWithMeta.meta?.pagination?.pageCount}');

// Advanced search with multiple fields
final searchResults = await baseService.search<Article>(
  'articles',
  query: 'flutter development',
  searchFields: ['title', 'content', 'tags'], // Search across multiple fields
  additionalFilters: {
    'publishedAt': {'\$notNull': true}, // Only published articles
    'author': {'\$in': [1, 2, 3]}, // Specific authors
  },
  populate: true,
  page: 1,
  pageSize: 20,
  sort: 'publishedAt:desc',
  fromJson: Article.fromJson,
);

// Create new article (Strapi v5 data wrapper format)
final newArticle = await baseService.create<Article>(
  'articles',
  {
    'title': 'Getting Started with Flutter',
    'content': 'Flutter is a powerful framework...',
    'tags': ['flutter', 'mobile', 'development'],
    'publishedAt': DateTime.now().toIso8601String(),
    'author': 1, // Reference to author ID
  },
  fromJson: Article.fromJson,
);

// Update existing article
final updatedArticle = await baseService.update<Article>(
  'articles',
  '123',
  {
    'title': 'Updated: Getting Started with Flutter',
    'content': 'Updated content here...',
  },
  fromJson: Article.fromJson,
);

// Get single article by ID
final singleArticle = await baseService.getById<Article>(
  'articles',
  '123',
  populate: true,
  fromJson: Article.fromJson,
);

// Delete article
await baseService.delete('articles', '123');
```

### 6. File Upload & Media Management

```dart
final apiClient = ref.read(apiClientProvider);

// Single file upload with metadata
final uploadResponse = await apiClient.post<Map<String, dynamic>>(
  ApiConfig.uploadEndpoint, // '/upload'
  data: FormData.fromMap({
    'files': await MultipartFile.fromFile(
      '/path/to/image.jpg',
      filename: 'profile-picture.jpg',
    ),
    'fileInfo': jsonEncode({
      'alternativeText': 'User profile picture',
      'caption': 'Profile photo for John Doe',
    }),
  }),
  onSendProgress: (sent, total) {
    final progress = (sent / total * 100).toInt();
    print('Upload progress: $progress%');
    // Update UI progress indicator
  },
);

// Multiple files upload
final multipleFiles = await apiClient.post<Map<String, dynamic>>(
  ApiConfig.uploadEndpoint,
  data: FormData.fromMap({
    'files': [
      await MultipartFile.fromFile('/path/to/image1.jpg'),
      await MultipartFile.fromFile('/path/to/image2.png'),
    ],
  }),
);

// Upload and associate with content
final articleWithImage = await baseService.create<Article>(
  'articles',
  {
    'title': 'Article with Featured Image',
    'content': 'Content here...',
    'featuredImage': uploadResponse.data['id'], // Link uploaded file
  },
  fromJson: Article.fromJson,
);
```

## 🔧 Detailed Configuration

### ApiConfig Class (`config/api_config.dart`)

The `ApiConfig` class provides centralized configuration for all API operations:

```dart
class ApiConfig {
  // Environment-aware base URL (supports compile-time configuration)
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:1337/api',
  );
  
  // Strapi v5.17.0 compatible endpoints
  static const String authEndpoint = '/auth/local';
  static const String registerEndpoint = '/auth/local/register';
  static const String generatePasswordEndpoint = '/auth/generate-password';
  static const String changePasswordEndpoint = '/auth/change-password';
  static const String sendEmailConfirmationEndpoint = '/auth/send-email-confirmation';
  static const String meEndpoint = '/users/me';
  static const String uploadEndpoint = '/upload';
  
  // Mobile-optimized timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
  
  // Secure storage keys for persistent data
  static const String credentialsEmailKey = 'strapi_credentials_email';
  static const String credentialsPasswordKey = 'strapi_credentials_password';
  static const String userKey = 'strapi_user';
  
  // Standard HTTP headers for Strapi v5
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest', // Required for CSRF protection
  };
  
  // Headers with JWT authentication
  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
  
  // Default population for Strapi v5 (populates all first-level relations)
  static Map<String, dynamic> get defaultPopulateParams => {
    'populate': '*',
  };
  
  // Advanced pagination with filtering support
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
```

### Environment-Specific Configuration

```bash
# Development
flutter run --dart-define=API_BASE_URL=http://localhost:1337/api

# Staging
flutter run --dart-define=API_BASE_URL=https://staging-api.example.com/api

# Production
flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com/api
```

### Secure Storage Configuration

```dart
// Production-ready secure storage configuration
import 'package:flutter_app_ersta/src/core/api/config/api_config.dart';

const secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
    sharedPreferencesName:
        ApiConfig.secureStorageAndroidSharedPreferencesName,
    preferencesKeyPrefix: ApiConfig.secureStorageAndroidPreferencesKeyPrefix,
  ),
  iOptions: IOSOptions(
    accountName: ApiConfig.secureStorageIosAccountName,
    accessibility: ApiConfig.secureStorageIosAccessibility,
    synchronizable: ApiConfig.secureStorageIosSynchronizable,
  ),
);

// Storage keys are defined in ApiConfig for consistency
// - credentialsEmailKey: User's email for re-authentication
// - credentialsPasswordKey: User's password (encrypted by platform)
// - userKey: JSON-serialized user profile data
```

## 🔄 Comprehensive Authentication State Management

The authentication system uses Freezed for immutable state and computed properties:

### AuthenticationState Model (`services/auth_service.dart:14-28`)

```dart
@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    @Default(false) bool isLoading,           // Request in progress
    @Default(false) bool isUserAuthenticated, // User has valid credentials
    @Default(false) bool isEmailVerified,     // Email is confirmed
    @Default(false) bool isInitialized,       // Service initialization complete
    StrapiUser? user,                         // Current user profile
    String? error,                            // Last error message
  }) = _AuthenticationState;

  const AuthenticationState._();

  // Computed property: user is fully authenticated when both logged in AND email verified
  bool get isAuthenticationCompleted => isUserAuthenticated && isEmailVerified;
}
```

### State Transitions

1. **Initial State**: `isLoading: true, isInitialized: false`
2. **Initialized**: `isInitialized: true, isLoading: false`
3. **Authenticating**: `isLoading: true`
4. **Authenticated (Unverified)**: `isUserAuthenticated: true, isEmailVerified: false`
5. **Fully Authenticated**: `isUserAuthenticated: true, isEmailVerified: true`
6. **Error State**: `error: "Error message", isLoading: false`

### State-Based UI Rendering

```dart
class AuthenticationWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authServiceProvider);
    final authService = ref.read(authServiceProvider.notifier);
    
    // Show splash screen during initialization
    if (!authState.isInitialized) {
      return const SplashScreen();
    }
    
    // Show loading overlay during authentication operations
    if (authState.isLoading) {
      return Stack([
        _buildCurrentScreen(authState),
        const LoadingOverlay(),
      ]);
    }
    
    // Handle error states
    if (authState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authState.error!)),
        );
      });
    }
    
    return _buildCurrentScreen(authState);
  }
  
  Widget _buildCurrentScreen(AuthenticationState state) {
    if (state.isAuthenticationCompleted) {
      return const HomeScreen(); // Full access to app
    } else if (state.isUserAuthenticated && !state.isEmailVerified) {
      return EmailVerificationScreen(
        user: state.user!,
        onResendEmail: () => _resendVerificationEmail(state.user!.email),
      );
    } else {
      return const LoginScreen(); // User needs to authenticate
    }
  }
  
  Future<void> _resendVerificationEmail(String email) async {
    final authService = ref.read(authServiceProvider.notifier);
    await authService.sendEmailConfirmation(
      SendEmailConfirmationRequest(email: email),
    );
  }
}
```

## 📱 Type-Safe Data Models

### Authentication Models (`models/auth_models.dart`)

All authentication models use `@JsonSerializable` for automatic serialization:

```dart
// Login request - supports both email and username
@JsonSerializable()
class LoginRequest {
  LoginRequest({required this.identifier, required this.password});
  
  factory LoginRequest.fromJson(Map<String, dynamic> json) => 
      _$LoginRequestFromJson(json);
  
  final String identifier; // Can be email or username
  final String password;
  
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

// Registration request with validation
@JsonSerializable()
class RegisterRequest {
  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
  });
  
  factory RegisterRequest.fromJson(Map<String, dynamic> json) => 
      _$RegisterRequestFromJson(json);
  
  final String username;  // Must be unique
  final String email;     // Must be valid email format
  final String password;  // Subject to Strapi password policy
  
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

// Authentication response from Strapi
@JsonSerializable(explicitToJson: true)
class AuthResponse {
  AuthResponse({this.jwt, required this.user});
  
  factory AuthResponse.fromJson(Map<String, dynamic> json) => 
      _$AuthResponseFromJson(json);
  
  final String? jwt;      // JWT token (null if email verification required)
  final StrapiUser user;  // User profile data
  
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

// Complete Strapi user model
@JsonSerializable(explicitToJson: true)
class StrapiUser {
  StrapiUser({
    required this.id,
    required this.username,
    required this.email,
    this.provider,
    this.confirmed,    // Email verification status
    this.blocked,      // Account status
    this.createdAt,
    this.updatedAt,
  });
  
  factory StrapiUser.fromJson(Map<String, dynamic> json) => 
      _$StrapiUserFromJson(json);
  
  final int id;
  final String username;
  final String email;
  final String? provider;      // 'local', 'google', 'facebook', etc.
  final bool? confirmed;       // Email confirmation status
  final bool? blocked;         // Account blocked by admin
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  Map<String, dynamic> toJson() => _$StrapiUserToJson(this);
  
  // Convenience getters
  bool get isEmailConfirmed => confirmed ?? false;
  bool get isBlocked => blocked ?? false;
}

// Password change with current password verification
class ChangePasswordRequest {
  ChangePasswordRequest({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });
  
  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => 
      ChangePasswordRequest(
        currentPassword: json['currentPassword'] as String,
        password: json['password'] as String,
        passwordConfirmation: json['passwordConfirmation'] as String,
      );
  
  final String currentPassword;
  final String password;
  final String passwordConfirmation;
  
  Map<String, dynamic> toJson() => {
    'currentPassword': currentPassword,
    'password': password,
    'passwordConfirmation': passwordConfirmation,
  };
}

// Email confirmation resend
@JsonSerializable()
class SendEmailConfirmationRequest {
  SendEmailConfirmationRequest({required this.email});
  
  factory SendEmailConfirmationRequest.fromJson(Map<String, dynamic> json) => 
      _$SendEmailConfirmationRequestFromJson(json);
  
  final String email;
  
  Map<String, dynamic> toJson() => _$SendEmailConfirmationRequestToJson(this);
}

// Additional models for complete auth flow
@JsonSerializable()
class ForgotPasswordRequest {
  ForgotPasswordRequest({required this.email});
  
  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) => 
      _$ForgotPasswordRequestFromJson(json);
  
  final String email;
  
  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

@JsonSerializable()
class ResetPasswordRequest {
  ResetPasswordRequest({
    required this.code,
    required this.password,
    required this.passwordConfirmation,
  });
  
  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) => 
      _$ResetPasswordRequestFromJson(json);
  
  final String code;                    // Reset token from email
  final String password;
  final String passwordConfirmation;
  
  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}
```

## 🛡️ Comprehensive Error Handling System

### Exception Hierarchy (`exceptions/api_exceptions.dart`)

The API provides a comprehensive exception hierarchy for different error scenarios:

```dart
// Base exception class
abstract class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode, this.data});
  
  final String message;      // Human-readable error message
  final int? statusCode;     // HTTP status code
  final dynamic data;        // Raw response data from server
}

// Network connectivity issues
class NetworkException extends ApiException {
  const NetworkException({required super.message, super.statusCode, super.data});
}

// HTTP timeout errors
class TimeoutException extends ApiException {
  const TimeoutException({required super.message, super.statusCode, super.data});
}

// 401 - Authentication failed
class AuthenticationException extends ApiException {
  const AuthenticationException({required super.message, super.statusCode, super.data});
}

// 403 - Access denied
class UnauthorizedException extends ApiException {
  const UnauthorizedException({required super.message, super.statusCode, super.data});
}

// 400 - Validation errors with field details
class ValidationException extends ApiException {
  const ValidationException({
    required super.message,
    super.statusCode,
    super.data,
    this.errors,  // Field-specific validation errors
  });
  
  final Map<String, List<String>>? errors;
}

// 404 - Resource not found
class NotFoundException extends ApiException {
  const NotFoundException({required super.message, super.statusCode, super.data});
}

// 500+ - Server errors with Strapi error details
class ServerException extends ApiException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.data,
    this.apiError,  // Detailed Strapi error information
  });
  
  final ApiError? apiError;
}
```

### Error Handling Best Practices

```dart
try {
  final response = await authService.login(loginRequest);
  // Handle successful login
  navigateToHome();
} on ValidationException catch (e) {
  // Handle validation errors (400)
  if (e.errors != null) {
    // Display field-specific errors
    e.errors!.forEach((field, messages) {
      print('$field: ${messages.join(", ")}');
    });
  } else {
    // Generic validation error
    showError(e.message);
  }
} on AuthenticationException catch (e) {
  // Handle invalid credentials (401)
  showError('Invalid email or password');
  clearPasswordField();
} on NetworkException catch (e) {
  // Handle network issues
  showError('Please check your internet connection');
  showRetryButton();
} on TimeoutException catch (e) {
  // Handle timeout
  showError('Request timed out. Please try again.');
} on ServerException catch (e) {
  // Handle server errors (500+) with detailed info
  print('Server error: ${e.apiError?.message}');
  print('Error details: ${e.apiError?.details}');
  showError('Server error occurred. Please try again later.');
} on ApiException catch (e) {
  // Catch any other API exceptions
  showError(e.message);
} catch (e) {
  // Handle unexpected errors
  print('Unexpected error: $e');
  showError('An unexpected error occurred');
}
```

### Automatic Exception Conversion

Dio exceptions are automatically converted to typed API exceptions:

```dart
// In ApiExceptionHandler.handleDioException()
static ApiException handleDioException(DioException dioException) {
  switch (dioException.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return TimeoutException(message: 'Request timeout');
    
    case DioExceptionType.connectionError:
      return NetworkException(message: 'Connection error');
    
    case DioExceptionType.badResponse:
      final statusCode = dioException.response?.statusCode;
      final data = dioException.response?.data;
      
      switch (statusCode) {
        case 400:
          return ValidationException(
            message: _extractErrorMessage(data),
            statusCode: statusCode,
            data: data,
          );
        case 401:
          return AuthenticationException(
            message: 'Authentication failed',
            statusCode: statusCode,
            data: data,
          );
        // ... other status codes
      }
  }
}
```

## 🔍 Strapi v5 Search & Filtering

```dart
// Advanced search with filters
final results = await baseService.search<Article>(
  'articles',
  query: 'flutter development',
  searchFields: ['title', 'content', 'tags.name'],
  additionalFilters: {
    'publishedAt': {'\$notNull': true},
    'category': {'\$in': ['tech', 'programming']},
  },
  sort: 'publishedAt:desc',
  page: 1,
  pageSize: 20,
  fromJson: Article.fromJson,
);

// Pagination with meta
final articlesWithMeta = await baseService.getListWithMeta<Article>(
  'articles',
  page: 2,
  pageSize: 10,
  sort: 'createdAt:desc',
  fromJson: Article.fromJson,
);

print('Total articles: ${articlesWithMeta.meta?.pagination?.total}');
```

## 🧪 Testing

```dart
// Model serialization tests
test('AuthResponse with refresh token', () {
  final response = AuthResponse(
    jwt: 'token123',
    user: StrapiUser(id: 1, username: 'test', email: 'test@example.com'),
    refreshToken: 'refresh123',
  );

  final json = response.toJson();
  final fromJson = AuthResponse.fromJson(json);
  
  expect(fromJson.refreshToken, equals('refresh123'));
});

// API service tests
test('Search functionality', () async {
  final service = MockBaseApiService();
  
  final results = await service.search<Article>(
    'articles',
    query: 'test',
    searchFields: ['title'],
    fromJson: Article.fromJson,
  );
  
  expect(results.isNotEmpty, true);
});
```

## 🚀 Production Deployment

### Environment Variables

```bash
# Development
flutter run --dart-define=API_BASE_URL=http://localhost:1337/api

# Staging
flutter run --dart-define=API_BASE_URL=https://staging-api.yourapp.com/api

# Production
flutter build apk --dart-define=API_BASE_URL=https://api.yourapp.com/api
```

### Security Checklist

- ✅ HTTPS URLs for production
- ✅ Secure token storage with FlutterSecureStorage
- ✅ Automatic token refresh and cleanup
- ✅ Comprehensive error handling
- ✅ Input validation on all requests
- ✅ No hardcoded sensitive data
- ✅ Timeout configurations for mobile networks

## 📦 Dependencies

```yaml
dependencies:
  dio: ^5.4.3+1
  flutter_secure_storage: ^9.2.4
  json_annotation: ^4.9.0
  flutter_riverpod: ^2.5.1
  logging: ^1.2.0

dev_dependencies:
  build_runner: ^2.4.15
  json_serializable: ^6.8.0
  mockito: ^5.4.4
```

## 🔧 Integration Patterns

### Authentication Flow Helper

The codebase includes an `AuthenticationFlowHelper` class that simplifies common authentication operations:

```dart
class AuthenticationFlowHelper {
  // Registration with automatic username generation
  Future<void> registerEmail({
    required AppLocalizations l10n,
    required String email,
    required String password,
    required void Function({String? errorMessage}) onRegisterDone,
  });

  // Login with email verification handling
  Future<void> login({
    required AppLocalizations l10n,
    required String email,
    required String password,
    required void Function({String? errorMessage, bool? isEmailVerified}) onLoginDone,
  });

  // Check email verification status
  Future<void> checkEmailVerification({
    required AppLocalizations l10n,
    required void Function({String? errorMessage, bool? isEmailVerified}) onCheckDone,
  });

  // Resend email verification
  Future<void> resendEmailVerification({
    required AppLocalizations l10n,
    required void Function({String? errorMessage}) onResendDone,
  });
}
```

### Route Guards

The API integrates with navigation guards for protecting routes:

```dart
class AuthenticationGuard extends BaseGuard {
  @override
  Widget buildGuardLogic(BuildContext context, WidgetRef ref) {
    final authenticationState = ref.watch(authServiceProvider);

    if (!authenticationState.isInitialized) {
      return loadingWidget;
    }

    if (authenticationState.isAuthenticationCompleted) {
      return child; // Allow access
    } else {
      redirect(context); // Redirect to login
      return emptyWidget;
    }
  }
}
```

### Error Mapping

Comprehensive error mapping with localization support:

```dart
class ErrorMapper {
  static String mapErrorToUserMessage(dynamic error, AppLocalizations l10n) {
    if (error is ApiException) {
      return _mapApiException(error, l10n);
    }
    return l10n.auth_error_unknown_error;
  }
  
  // Maps specific Strapi error messages
  static String? _mapByMessage(String message, AppLocalizations l10n) {
    if (message.contains('your account email is not confirmed')) {
      return l10n.auth_error_email_not_confirmed;
    }
    // ... more specific mappings
  }
}
```

## 🔧 Setup

1. **Add dependencies** to `pubspec.yaml`
2. **Install packages**: `flutter pub get`
3. **Generate models**: `dart run build_runner build`
4. **Configure API base URL** in `ApiConfig.baseUrl`
5. **Use providers**: `authServiceProvider`, `apiClientProvider` in your widgets

## 🆕 Key Features

- ✅ **Credential-based Authentication** with secure storage of user credentials
- ✅ **Email Verification Flow** with automatic re-authentication
- ✅ **Enhanced Strapi v5 compatibility** with proper response handling
- ✅ **Advanced search and filtering** with `$containsi`, `$or` operators
- ✅ **File upload with progress** tracking
- ✅ **Comprehensive error handling** with Strapi-specific error mapping
- ✅ **Population and pagination** helpers for Strapi v5
- ✅ **State management integration** with Freezed and Riverpod
- ✅ **Localized error messages** with extensive error mapping

## 🔒 Security Benefits

1. **Encrypted Credential Storage** - User credentials securely stored in system keychain/keystore
2. **JWT Token Management** - JWTs stored in memory only, not persisted
3. **Automatic Re-authentication** - Seamless re-login using stored credentials
4. **Email Verification Support** - Full email confirmation flow integration
5. **Secure by Default** - No sensitive data in plain text storage
6. **Auto Token Refresh** - Automatic retry with fresh tokens on 401 errors
7. **Comprehensive Error Handling** - Safe error exposure with detailed Strapi error mapping

## 🚀 Production Ready

✅ **Strapi v5.17.0 Compatible**  
✅ **Credential-based Authentication**  
✅ **Cross-platform iOS/Android**  
✅ **Comprehensive Error Handling**  
✅ **Type-safe Serialization with Freezed**  
✅ **Security Best Practices**  
✅ **State Management Integration**  
✅ **Email Verification Flow**  
✅ **Localization Support**

Ready for production deployment with Flutter & Strapi! 🚀
