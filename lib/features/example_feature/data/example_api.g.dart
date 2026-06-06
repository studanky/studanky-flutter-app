// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _ExampleApi implements ExampleApi {
  _ExampleApi(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<StrapiListResponse<ExampleItemDto>> fetchItems(
    Map<String, dynamic> queries,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(queries);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<StrapiListResponse<ExampleItemDto>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/example-items',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StrapiListResponse<ExampleItemDto> _value;
    try {
      _value = StrapiListResponse<ExampleItemDto>.fromJson(
        _result.data!,
        (json) => ExampleItemDto.fromJson(json as Map<String, dynamic>),
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

@ProviderFor(exampleApi)
final exampleApiProvider = ExampleApiProvider._();

final class ExampleApiProvider
    extends $FunctionalProvider<ExampleApi, ExampleApi, ExampleApi>
    with $Provider<ExampleApi> {
  ExampleApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exampleApiProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exampleApiHash();

  @$internal
  @override
  $ProviderElement<ExampleApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExampleApi create(Ref ref) {
    return exampleApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExampleApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExampleApi>(value),
    );
  }
}

String _$exampleApiHash() => r'8c89319673193611cc79927644da347e00de7210';
