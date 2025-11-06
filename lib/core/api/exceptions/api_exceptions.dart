import 'package:dio/dio.dart';
import 'package:studanky_flutter_app/core/api/models/api_response.dart';

enum StrapiErrorType {
  applicationError('ApplicationError'),
  validationError('ValidationError'),
  forbiddenError('ForbiddenError'),
  unauthorizedError('UnauthorizedError'),
  notFoundError('NotFoundError'),
  paginationError('PaginationError'),
  notImplementedError('NotImplementedError'),
  payloadTooLargeError('PayloadTooLargeError'),
  policyError('PolicyError'),
  unknown('Unknown');

  const StrapiErrorType(this.name);

  final String name;

  static StrapiErrorType fromName(String? name) {
    if (name == null) return unknown;
    return StrapiErrorType.values.firstWhere(
      (type) => type.name == name,
      orElse: () => unknown,
    );
  }
}

abstract class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.strapiErrorType,
  });

  final String message;
  final int? statusCode;
  final dynamic data;
  final StrapiErrorType? strapiErrorType;

  @override
  String toString() =>
      'ApiException: $message (Status: $statusCode, Type: ${strapiErrorType?.name})';
}

class NetworkException extends ApiException {
  const NetworkException({
    required super.message,
    super.statusCode,
    super.data,
    super.strapiErrorType,
  });
}

class ServerException extends ApiException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.data,
    super.strapiErrorType,
    this.apiError,
  });

  final ApiError? apiError;
}

class AuthenticationException extends ApiException {
  const AuthenticationException({
    required super.message,
    super.statusCode,
    super.data,
    super.strapiErrorType,
  });
}

class ValidationException extends ApiException {
  const ValidationException({
    required super.message,
    super.statusCode,
    super.data,
    super.strapiErrorType,
    this.errors,
  });

  final Map<String, List<String>>? errors;
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    required super.message,
    super.statusCode,
    super.data,
    super.strapiErrorType,
  });
}

class NotFoundException extends ApiException {
  const NotFoundException({
    required super.message,
    super.statusCode,
    super.data,
    super.strapiErrorType,
  });
}

class TimeoutException extends ApiException {
  const TimeoutException({
    required super.message,
    super.statusCode,
    super.data,
    super.strapiErrorType,
  });
}

class ApiExceptionHandler {
  static ApiException handleDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          message: 'Request timeout. Please check your internet connection.',
          statusCode: dioException.response?.statusCode,
          data: dioException.response?.data,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Connection error. Please check your internet connection.',
          statusCode: dioException.response?.statusCode,
          data: dioException.response?.data,
        );

      case DioExceptionType.badResponse:
        final statusCode = dioException.response?.statusCode;
        final data = dioException.response?.data;

        switch (statusCode) {
          case 400:
            try {
              final apiError = ApiError.fromJson(data['error'] ?? data);
              return ValidationException(
                message: apiError.message,
                statusCode: statusCode,
                data: data,
                strapiErrorType: StrapiErrorType.fromName(apiError.name),
              );
            } catch (_) {
              return ValidationException(
                message: _extractErrorMessage(
                  data,
                  'Validation error occurred.',
                ),
                statusCode: statusCode,
                data: data,
                strapiErrorType: StrapiErrorType.validationError,
              );
            }

          case 401:
            final errorName = _extractErrorName(data);
            return AuthenticationException(
              message: _extractErrorMessage(
                data,
                'Authentication failed. Please login again.',
              ),
              statusCode: statusCode,
              data: data,
              strapiErrorType: StrapiErrorType.fromName(errorName),
            );

          case 403:
            final errorName = _extractErrorName(data);
            return UnauthorizedException(
              message: _extractErrorMessage(
                data,
                'Access denied. You don\'t have permission.',
              ),
              statusCode: statusCode,
              data: data,
              strapiErrorType: StrapiErrorType.fromName(errorName),
            );

          case 404:
            final errorName = _extractErrorName(data);
            return NotFoundException(
              message: _extractErrorMessage(data, 'Resource not found.'),
              statusCode: statusCode,
              data: data,
              strapiErrorType: StrapiErrorType.fromName(errorName),
            );

          case 500:
          default:
            try {
              final apiError = ApiError.fromJson(data['error'] ?? data);
              return ServerException(
                message: apiError.message,
                statusCode: statusCode,
                data: data,
                strapiErrorType: StrapiErrorType.fromName(apiError.name),
                apiError: apiError,
              );
            } catch (_) {
              return ServerException(
                message: _extractErrorMessage(data, 'Server error occurred.'),
                statusCode: statusCode,
                data: data,
                strapiErrorType: StrapiErrorType.applicationError,
              );
            }
        }

      case DioExceptionType.cancel:
        return UnknownApiException(
          message: 'Request was cancelled.',
          statusCode: dioException.response?.statusCode,
          data: dioException.response?.data,
        );

      case DioExceptionType.unknown:
      default:
        return UnknownApiException(
          message: dioException.message ?? 'Unknown error occurred.',
          statusCode: dioException.response?.statusCode,
          data: dioException.response?.data,
        );
    }
  }

  static ApiException handleGenericException(Exception exception) {
    return UnknownApiException(
      message: exception.toString(),
      strapiErrorType: StrapiErrorType.unknown,
    );
  }

  static String? _extractErrorName(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        final error = data['error'];
        if (error is Map<String, dynamic>) {
          return error['name'] as String?;
        }
        return data['name'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static String _extractErrorMessage(dynamic data, String fallbackMessage) {
    try {
      if (data is Map<String, dynamic>) {
        final error = data['error'];
        if (error is Map<String, dynamic>) {
          final message = error['message'] as String?;
          if (message != null && message.isNotEmpty) {
            return message;
          }
        }
        final directMessage = data['message'] as String?;
        if (directMessage != null && directMessage.isNotEmpty) {
          return directMessage;
        }
      }
      return fallbackMessage;
    } catch (_) {
      return fallbackMessage;
    }
  }
}

class UnknownApiException extends ApiException {
  const UnknownApiException({
    required super.message,
    super.statusCode,
    super.data,
    super.strapiErrorType,
  });
}
