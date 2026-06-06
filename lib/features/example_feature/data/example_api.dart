import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/dio/dio_provider.dart';
import 'package:studanky_flutter_app/core/api/models/strapi_response.dart';
import 'package:studanky_flutter_app/features/example_feature/dtos/example_item_dto.dart';

part 'example_api.g.dart';

/// Remote data source for the example collection.
@RestApi()
abstract class ExampleApi {
  factory ExampleApi(Dio dio, {String? baseUrl}) = _ExampleApi;

  @GET(ApiConfig.exampleItemsEndpoint)
  Future<StrapiListResponse<ExampleItemDto>> fetchItems(
    @Queries() Map<String, dynamic> queries,
  );
}

@riverpod
ExampleApi exampleApi(Ref ref) => ExampleApi(ref.watch(dioProvider));
