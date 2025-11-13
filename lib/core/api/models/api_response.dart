import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
class ApiResponse<T> {
  ApiResponse({required this.data, this.meta});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  final T data;
  final ApiMeta? meta;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

@JsonSerializable(explicitToJson: true)
class ApiMeta {
  ApiMeta({this.pagination});

  factory ApiMeta.fromJson(Map<String, dynamic> json) =>
      _$ApiMetaFromJson(json);

  final ApiPagination? pagination;

  Map<String, dynamic> toJson() => _$ApiMetaToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ApiPagination {
  ApiPagination({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  factory ApiPagination.fromJson(Map<String, dynamic> json) =>
      _$ApiPaginationFromJson(json);

  final int page;
  final int pageSize;
  final int pageCount;
  final int total;

  Map<String, dynamic> toJson() => _$ApiPaginationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ApiError {
  ApiError({
    required this.status,
    required this.name,
    required this.message,
    this.details,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  final int status;
  final String name;
  final String message;
  final Map<String, dynamic>? details;

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}
