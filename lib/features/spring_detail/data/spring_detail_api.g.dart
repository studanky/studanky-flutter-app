// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spring_detail_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _SpringDetailApi implements SpringDetailApi {
  _SpringDetailApi(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<StrapiSingleResponse<SpringDetailDto>> getDetail(
    String documentId,
    Map<String, dynamic> queries,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(queries);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<StrapiSingleResponse<SpringDetailDto>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/springs/${documentId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StrapiSingleResponse<SpringDetailDto> _value;
    try {
      _value = StrapiSingleResponse<SpringDetailDto>.fromJson(
        _result.data!,
        (json) => SpringDetailDto.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<StrapiListResponse<ReportDto>> getReports(
    String documentId,
    int page,
    int pageSize,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'pageSize': pageSize,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<StrapiListResponse<ReportDto>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/springs/${documentId}/reports',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StrapiListResponse<ReportDto> _value;
    try {
      _value = StrapiListResponse<ReportDto>.fromJson(
        _result.data!,
        (json) => ReportDto.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(springDetailApi)
final springDetailApiProvider = SpringDetailApiProvider._();

final class SpringDetailApiProvider
    extends
        $FunctionalProvider<SpringDetailApi, SpringDetailApi, SpringDetailApi>
    with $Provider<SpringDetailApi> {
  SpringDetailApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'springDetailApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$springDetailApiHash();

  @$internal
  @override
  $ProviderElement<SpringDetailApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SpringDetailApi create(Ref ref) {
    return springDetailApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpringDetailApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpringDetailApi>(value),
    );
  }
}

String _$springDetailApiHash() => r'70cf5e1382226268860d2b30b758ebae5f1cd99d';
