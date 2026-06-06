import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:studanky_flutter_app/core/api/exceptions/api_exceptions.dart';

part 'api_result.freezed.dart';

/// Outcome of a data-layer call: either [Success] with a value or [Failure]
/// with a typed [ApiException]. Consumers handle it exhaustively via `switch`.
@freezed
sealed class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(ApiException exception) = Failure<T>;

  const ApiResult._();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
    Success<T>(:final data) => data,
    Failure<T>() => null,
  };

  ApiException? get exceptionOrNull => switch (this) {
    Success<T>() => null,
    Failure<T>(:final exception) => exception,
  };

  /// Returns the value on success or throws the captured exception on failure.
  T get orThrow => switch (this) {
    Success<T>(:final data) => data,
    Failure<T>(:final exception) => throw exception,
  };
}

extension ApiResultExtensions<T> on ApiResult<T> {
  ApiResult<R> map<R>(R Function(T data) mapper) => switch (this) {
    Success<T>(:final data) => ApiResult.success(mapper(data)),
    Failure<T>(:final exception) => ApiResult.failure(exception),
  };

  Future<ApiResult<R>> mapAsync<R>(Future<R> Function(T data) mapper) async =>
      switch (this) {
        Success<T>(:final data) => ApiResult.success(await mapper(data)),
        Failure<T>(:final exception) => ApiResult.failure(exception),
      };

  ApiResult<R> flatMap<R>(ApiResult<R> Function(T data) mapper) =>
      switch (this) {
        Success<T>(:final data) => mapper(data),
        Failure<T>(:final exception) => ApiResult.failure(exception),
      };

  Future<ApiResult<R>> flatMapAsync<R>(
    Future<ApiResult<R>> Function(T data) mapper,
  ) async => switch (this) {
    Success<T>(:final data) => await mapper(data),
    Failure<T>(:final exception) => ApiResult.failure(exception),
  };
}
