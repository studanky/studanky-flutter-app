import 'package:dio/dio.dart';
import 'package:studanky_flutter_app/core/api/exceptions/api_exceptions.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';

/// Runs [request] and normalises any error into an [ApiResult.failure],
/// converting Dio and generic errors into typed [ApiException]s.
///
/// This keeps repositories free of repetitive try/catch blocks while ensuring
/// errors never leak across the data-layer boundary as raw [DioException]s.
Future<ApiResult<T>> guardApiCall<T>(Future<T> Function() request) async {
  try {
    return ApiResult.success(await request());
  } on ApiException catch (exception) {
    return ApiResult.failure(exception);
  } on DioException catch (exception) {
    return ApiResult.failure(
      ApiExceptionHandler.handleDioException(exception),
    );
  } catch (error) {
    return ApiResult.failure(
      ApiExceptionHandler.handleGenericException(
        error is Exception ? error : Exception(error.toString()),
      ),
    );
  }
}
