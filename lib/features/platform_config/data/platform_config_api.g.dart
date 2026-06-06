// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_config_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _PlatformConfigApi implements PlatformConfigApi {
  _PlatformConfigApi(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<StrapiSingleResponse<PlatformConfigDto>> fetch(
    Map<String, dynamic> queries,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(queries);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<StrapiSingleResponse<PlatformConfigDto>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/platform-config',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StrapiSingleResponse<PlatformConfigDto> _value;
    try {
      _value = StrapiSingleResponse<PlatformConfigDto>.fromJson(
        _result.data!,
        (json) => PlatformConfigDto.fromJson(json as Map<String, dynamic>),
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

@ProviderFor(platformConfigApi)
final platformConfigApiProvider = PlatformConfigApiProvider._();

final class PlatformConfigApiProvider
    extends
        $FunctionalProvider<
          PlatformConfigApi,
          PlatformConfigApi,
          PlatformConfigApi
        >
    with $Provider<PlatformConfigApi> {
  PlatformConfigApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'platformConfigApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$platformConfigApiHash();

  @$internal
  @override
  $ProviderElement<PlatformConfigApi> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlatformConfigApi create(Ref ref) {
    return platformConfigApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlatformConfigApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlatformConfigApi>(value),
    );
  }
}

String _$platformConfigApiHash() => r'0ca7d930749a28eac46d725e2415b2df7d71189f';
