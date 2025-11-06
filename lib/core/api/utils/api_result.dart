import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:studanky_flutter_app/core/api/exceptions/api_exceptions.dart';

part 'api_result.freezed.dart';

@freezed
sealed class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(ApiException exception) = Failure<T>;

  const ApiResult._();

  bool get isSuccess => maybeWhen(success: (_) => true, orElse: () => false);
  bool get isFailure => !isSuccess;

  T? get dataOrNull => when(success: (data) => data, failure: (_) => null);

  ApiException? get exceptionOrNull =>
      when(success: (_) => null, failure: (exception) => exception);
}

extension ApiResultExtensions<T> on ApiResult<T> {
  ApiResult<R> map<R>(R Function(T data) mapper) {
    return when(
      success: (data) => ApiResult.success(mapper(data)),
      failure: ApiResult.failure,
    );
  }

  Future<ApiResult<R>> mapAsync<R>(Future<R> Function(T data) mapper) async {
    return when(
      success: (data) async => ApiResult.success(await mapper(data)),
      failure: ApiResult.failure,
    );
  }

  ApiResult<R> flatMap<R>(ApiResult<R> Function(T data) mapper) {
    return when(success: mapper, failure: ApiResult.failure);
  }

  Future<ApiResult<R>> flatMapAsync<R>(
    Future<ApiResult<R>> Function(T data) mapper,
  ) async {
    return when(success: mapper, failure: ApiResult.failure);
  }
}
