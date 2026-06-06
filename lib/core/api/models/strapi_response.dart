import 'package:json_annotation/json_annotation.dart';

part 'strapi_response.g.dart';

/// Strapi v5 envelope for collection (list) endpoints: `{ "data": [...], "meta": {...} }`.
@JsonSerializable(genericArgumentFactories: true)
class StrapiListResponse<T> {
  const StrapiListResponse({this.data = const [], this.meta});

  factory StrapiListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$StrapiListResponseFromJson(json, fromJsonT);

  final List<T> data;
  final StrapiMeta? meta;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$StrapiListResponseToJson(this, toJsonT);
}

/// Strapi v5 envelope for single-entity endpoints: `{ "data": {...}, "meta": {...} }`.
@JsonSerializable(genericArgumentFactories: true)
class StrapiSingleResponse<T> {
  const StrapiSingleResponse({required this.data, this.meta});

  factory StrapiSingleResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$StrapiSingleResponseFromJson(json, fromJsonT);

  final T data;
  final StrapiMeta? meta;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$StrapiSingleResponseToJson(this, toJsonT);
}

@JsonSerializable()
class StrapiMeta {
  const StrapiMeta({this.pagination});

  factory StrapiMeta.fromJson(Map<String, dynamic> json) =>
      _$StrapiMetaFromJson(json);

  final StrapiPagination? pagination;

  Map<String, dynamic> toJson() => _$StrapiMetaToJson(this);
}

@JsonSerializable()
class StrapiPagination {
  const StrapiPagination({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  factory StrapiPagination.fromJson(Map<String, dynamic> json) =>
      _$StrapiPaginationFromJson(json);

  final int page;
  final int pageSize;
  final int pageCount;
  final int total;

  Map<String, dynamic> toJson() => _$StrapiPaginationToJson(this);
}

/// Strapi v5 error payload found under the `error` key of an error response.
@JsonSerializable()
class ApiError {
  const ApiError({
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
