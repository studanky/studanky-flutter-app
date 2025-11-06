import 'package:studanky_flutter_app/core/api/exceptions/api_exceptions.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

class ErrorMapper {
  static String mapErrorToUserMessage(dynamic error, AppLocalizations l10n) {
    // Handle API exceptions (including converted DioExceptions)
    if (error is ApiException) {
      return _mapApiException(error, l10n);
    }

    // Handle generic exceptions
    if (error is Exception && error.toString() == 'Exception') {
      return l10n.auth_error_unknown_error;
    }

    // Fallback
    return error is Exception && error.toString().isNotEmpty
        ? error.toString()
        : l10n.auth_error_unknown_error;
  }

  static String _mapApiException(
    ApiException exception,
    AppLocalizations l10n,
  ) {
    // First try to map by message content (for Strapi-specific errors)
    final messageMapping = _mapByMessage(exception.message.toLowerCase(), l10n);
    if (messageMapping != null) {
      return messageMapping;
    }

    // Then fall back to type-based mapping
    switch (exception.runtimeType) {
      case const (NetworkException):
        return l10n.auth_error_network_error;

      case const (TimeoutException):
        return l10n.auth_error_network_error; // Treat timeout as network error

      case const (AuthenticationException):
        return l10n.auth_error_invalid_credentials;

      case const (UnauthorizedException):
        return l10n.auth_error_not_authenticated;

      case const (NotFoundException):
        return l10n.auth_error_unknown_error;

      case const (ValidationException):
        final validationException = exception as ValidationException;
        if (validationException.errors != null &&
            validationException.errors!.isNotEmpty) {
          return _formatValidationErrors(validationException.errors!);
        }
        return l10n.auth_error_invalid_parameters;

      case const (ServerException):
        return l10n.auth_error_server_error;

      default:
        return l10n.auth_error_unknown_error;
    }
  }

  static String? _mapByMessage(String message, AppLocalizations l10n) {
    // Map specific Strapi error messages to localized strings
    if (message.contains('this provider is disabled')) {
      return l10n.auth_error_provider_disabled;
    }

    if (message.contains('invalid identifier or password')) {
      return l10n.auth_error_invalid_credentials;
    }

    if (message.contains('your account email is not confirmed')) {
      return l10n.auth_error_email_not_confirmed;
    }

    if (message.contains('your account has been blocked') ||
        message.contains('account has been blocked by an administrator')) {
      return l10n.auth_error_account_blocked;
    }

    if (message.contains('you must be authenticated to reset your password')) {
      return l10n.auth_error_not_authenticated;
    }

    if (message.contains('the provided current password is invalid')) {
      return l10n.auth_error_invalid_current_password;
    }

    if (message.contains(
      'your new password must be different than your current password',
    )) {
      return l10n.auth_error_same_password;
    }

    if (message.contains('passwords do not match')) {
      return l10n.auth_error_passwords_do_not_match;
    }

    if (message.contains('incorrect code provided')) {
      return l10n.auth_error_incorrect_code;
    }

    if (message.contains('invalid callback url provided')) {
      return l10n.auth_error_invalid_callback;
    }

    if (message.contains('register action is currently disabled')) {
      return l10n.auth_error_registration_disabled;
    }

    if (message.contains('invalid parameters')) {
      return l10n.auth_error_invalid_parameters;
    }

    if (message.contains('impossible to find the default role')) {
      return l10n.auth_error_default_role_not_found;
    }

    if (message.contains('email or username are already taken')) {
      return l10n.auth_error_email_or_username_in_use;
    }

    if (message.contains('error sending confirmation email')) {
      return l10n.auth_error_email_send_error;
    }

    if (message.contains('invalid token')) {
      return l10n.auth_error_invalid_token;
    }

    if (message.contains('already confirmed')) {
      return l10n.auth_error_already_confirmed;
    }

    if (message.contains('user blocked')) {
      return l10n.auth_error_user_blocked;
    }

    // Connection/network related messages
    if (message.contains('connection error') || message.contains('network')) {
      return l10n.auth_error_network_error;
    }

    if (message.contains('timeout') || message.contains('request timeout')) {
      return l10n.auth_error_network_error;
    }

    if (message.contains('server error')) {
      return l10n.auth_error_server_error;
    }

    return null; // No specific mapping found
  }

  static String _formatValidationErrors(Map<String, List<String>> errors) {
    final messages = <String>[];

    errors.forEach((field, fieldErrors) {
      for (final error in fieldErrors) {
        messages.add('$field: $error');
      }
    });

    return messages.join('\n');
  }

  static bool isRetryableError(ApiException exception) {
    return exception is NetworkException ||
        exception is TimeoutException ||
        (exception is ServerException &&
            exception.statusCode != null &&
            exception.statusCode! >= 500);
  }

  static bool requiresAuthentication(ApiException exception) {
    return exception is AuthenticationException ||
        exception is UnauthorizedException;
  }
}
