// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'springs_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _SpringsApi implements SpringsApi {
  _SpringsApi(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<StrapiListResponse<SpringMapMarkerDto>> getMap(String bbox) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'bbox': bbox};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<StrapiListResponse<SpringMapMarkerDto>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/springs/map',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StrapiListResponse<SpringMapMarkerDto> _value;
    try {
      _value = StrapiListResponse<SpringMapMarkerDto>.fromJson(
        _result.data!,
        (json) => SpringMapMarkerDto.fromJson(json as Map<String, dynamic>),
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

@ProviderFor(springsApi)
final springsApiProvider = SpringsApiProvider._();

final class SpringsApiProvider
    extends $FunctionalProvider<SpringsApi, SpringsApi, SpringsApi>
    with $Provider<SpringsApi> {
  SpringsApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'springsApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$springsApiHash();

  @$internal
  @override
  $ProviderElement<SpringsApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SpringsApi create(Ref ref) {
    return springsApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpringsApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpringsApi>(value),
    );
  }
}

String _$springsApiHash() => r'5484fefa81672667c8151437ec9f166b91194aa8';
