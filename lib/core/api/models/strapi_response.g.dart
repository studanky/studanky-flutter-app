// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strapi_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StrapiListResponse<T> _$StrapiListResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => StrapiListResponse<T>(
  data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList() ?? const [],
  meta: json['meta'] == null
      ? null
      : StrapiMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StrapiListResponseToJson<T>(
  StrapiListResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'data': instance.data.map(toJsonT).toList(),
  'meta': instance.meta?.toJson(),
};

StrapiSingleResponse<T> _$StrapiSingleResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => StrapiSingleResponse<T>(
  data: fromJsonT(json['data']),
  meta: json['meta'] == null
      ? null
      : StrapiMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StrapiSingleResponseToJson<T>(
  StrapiSingleResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'data': toJsonT(instance.data),
  'meta': instance.meta?.toJson(),
};

StrapiMeta _$StrapiMetaFromJson(Map<String, dynamic> json) => StrapiMeta(
  pagination: json['pagination'] == null
      ? null
      : StrapiPagination.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StrapiMetaToJson(StrapiMeta instance) =>
    <String, dynamic>{'pagination': instance.pagination?.toJson()};

StrapiPagination _$StrapiPaginationFromJson(Map<String, dynamic> json) =>
    StrapiPagination(
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      pageCount: (json['pageCount'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$StrapiPaginationToJson(StrapiPagination instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
      'pageCount': instance.pageCount,
      'total': instance.total,
    };

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) => ApiError(
  status: (json['status'] as num).toInt(),
  name: json['name'] as String,
  message: json['message'] as String,
  details: json['details'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ApiErrorToJson(ApiError instance) => <String, dynamic>{
  'status': instance.status,
  'name': instance.name,
  'message': instance.message,
  'details': instance.details,
};
