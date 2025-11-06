import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/exceptions/api_exceptions.dart';
import 'package:studanky_flutter_app/core/api/interceptors/auth_interceptor.dart';
import 'package:studanky_flutter_app/core/api/interceptors/logging_interceptor.dart';
import 'package:studanky_flutter_app/core/api/services/auth_service.dart';

class ApiClient {
  ApiClient([AuthService? authService]) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: ApiConfig.defaultHeaders,
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    if (authService != null) {
      setupInterceptors(authService);
    }
  }

  late final Dio _dio;

  Dio get dio => _dio;

  void setupInterceptors(AuthService authService) {
    _dio.interceptors.clear();
    _dio.interceptors.addAll([
      AuthInterceptor(_dio, authService),
      LoggingInterceptor(),
    ]);
  }

  // Enhanced method for Strapi collection queries with populate
  Future<Response<T>> getCollection<T>(
    String collectionType, {
    Map<String, dynamic>? queryParameters,
    bool populate = true,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final params = <String, dynamic>{
      if (populate) ...ApiConfig.defaultPopulateParams,
      if (queryParameters != null) ...queryParameters,
    };

    return get<T>(
      '/$collectionType',
      queryParameters: params,
      options: options,
      cancelToken: cancelToken,
    );
  }

  // Enhanced method for Strapi single type queries
  Future<Response<T>> getSingleType<T>(
    String singleType, {
    Map<String, dynamic>? queryParameters,
    bool populate = true,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final params = <String, dynamic>{
      if (populate) ...ApiConfig.defaultPopulateParams,
      if (queryParameters != null) ...queryParameters,
    };

    return get<T>(
      '/$singleType',
      queryParameters: params,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ApiExceptionHandler.handleGenericException(e as Exception);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ApiExceptionHandler.handleGenericException(e as Exception);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ApiExceptionHandler.handleGenericException(e as Exception);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ApiExceptionHandler.handleGenericException(e as Exception);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ApiExceptionHandler.handleGenericException(e as Exception);
    }
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
