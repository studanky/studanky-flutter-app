import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/api/clients/api_client.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/models/api_response.dart';

abstract class BaseApiService {
  BaseApiService(this.apiClient);

  final ApiClient apiClient;

  Future<List<T>> getList<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool populate = false,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final params = <String, dynamic>{
      if (populate) ...ApiConfig.defaultPopulateParams,
      if (queryParameters != null) ...queryParameters,
    };

    final response = await apiClient.getCollection(
      endpoint,
      queryParameters: params,
      populate: populate,
    );

    if (response.data is Map<String, dynamic>) {
      final responseData = response.data as Map<String, dynamic>;

      // Handle Strapi v5 response format
      if (responseData.containsKey('data')) {
        final dataList = responseData['data'] as List<dynamic>;
        return dataList
            .cast<Map<String, dynamic>>()
            .map((item) => fromJson(item))
            .toList();
      } else if (responseData is List) {
        // Fallback for direct array response
        return (responseData as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .map((item) => fromJson(item))
            .toList();
      }
    } else if (response.data is List) {
      return (response.data as List)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Unexpected response format');
  }

  Future<T> getById<T>(
    String endpoint,
    int id, {
    Map<String, dynamic>? queryParameters,
    bool populate = false,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final params = <String, dynamic>{
      if (populate) ...ApiConfig.defaultPopulateParams,
      if (queryParameters != null) ...queryParameters,
    };

    final response = await apiClient.get(
      '$endpoint/${id.toString()}',
      queryParameters: params,
    );

    if (response.data is Map<String, dynamic>) {
      final responseData = response.data as Map<String, dynamic>;

      // Handle Strapi v5 response format
      if (responseData.containsKey('data')) {
        final itemData = responseData['data'] as Map<String, dynamic>;
        return fromJson(itemData);
      } else {
        return fromJson(responseData);
      }
    }

    throw Exception('Unexpected response format');
  }

  Future<T> create<T>(
    String endpoint,
    Map<String, dynamic> data, {
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await apiClient.post(endpoint, data: {'data': data});

    if (response.data is Map<String, dynamic>) {
      final responseData = response.data as Map<String, dynamic>;

      if (responseData.containsKey('data')) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          responseData,
          (data) => data as Map<String, dynamic>,
        );
        return fromJson(apiResponse.data);
      } else {
        return fromJson(responseData);
      }
    }

    throw Exception('Unexpected response format');
  }

  Future<T> update<T>(
    String endpoint,
    String id,
    Map<String, dynamic> data, {
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final response = await apiClient.put('$endpoint/$id', data: {'data': data});

    if (response.data is Map<String, dynamic>) {
      final responseData = response.data as Map<String, dynamic>;

      if (responseData.containsKey('data')) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          responseData,
          (data) => data as Map<String, dynamic>,
        );
        return fromJson(apiResponse.data);
      } else {
        return fromJson(responseData);
      }
    }

    throw Exception('Unexpected response format');
  }

  Future<void> delete(String endpoint, String id) async {
    await apiClient.delete('$endpoint/$id');
  }

  Future<ApiResponse<List<T>>> getListWithMeta<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool populate = true,
    int page = 1,
    int pageSize = 25,
    String? sort,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final params = <String, dynamic>{
      if (populate) ...ApiConfig.defaultPopulateParams,
      ...ApiConfig.paginationParams(page: page, pageSize: pageSize, sort: sort),
      if (queryParameters != null) ...queryParameters,
    };

    final response = await apiClient.getCollection(
      endpoint,
      queryParameters: params,
      populate: populate,
    );

    if (response.data is Map<String, dynamic>) {
      final responseData = response.data as Map<String, dynamic>;

      // Handle Strapi v5 response format
      if (responseData.containsKey('data')) {
        final dataList = responseData['data'] as List<dynamic>;
        final items = dataList
            .cast<Map<String, dynamic>>()
            .map((item) => fromJson(item))
            .toList();

        // Extract meta information
        final meta = responseData.containsKey('meta')
            ? ApiMeta.fromJson(responseData['meta'] as Map<String, dynamic>)
            : null;

        return ApiResponse<List<T>>(data: items, meta: meta);
      }
    }

    throw Exception('Unexpected response format');
  }

  // Search method for Strapi v5
  Future<List<T>> search<T>(
    String endpoint, {
    required String query,
    List<String>? searchFields,
    Map<String, dynamic>? additionalFilters,
    bool populate = true,
    int page = 1,
    int pageSize = 25,
    String? sort,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final filters = <String, dynamic>{};

    // Add search filters
    if (searchFields != null && searchFields.isNotEmpty) {
      final searchConditions = searchFields
          .map(
            (field) => {
              field: {'\$containsi': query},
            },
          )
          .toList();

      filters['\$or'] = searchConditions;
    }

    // Add additional filters
    if (additionalFilters != null) {
      filters.addAll(additionalFilters);
    }

    final params = <String, dynamic>{
      if (populate) ...ApiConfig.defaultPopulateParams,
      ...ApiConfig.paginationParams(
        page: page,
        pageSize: pageSize,
        sort: sort,
        filters: {'filters': filters},
      ),
    };

    return getList<T>(
      endpoint,
      queryParameters: params,
      populate: populate,
      fromJson: fromJson,
    );
  }
}

class GenericApiService extends BaseApiService {
  GenericApiService(super.apiClient);
}

final genericApiServiceProvider = Provider<GenericApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GenericApiService(apiClient);
});
