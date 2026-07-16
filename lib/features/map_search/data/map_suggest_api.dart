import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:studanky_flutter_app/features/map_search/constants/map_search_constants.dart';
import 'package:studanky_flutter_app/features/map_search/dtos/map_suggest_response_dto.dart';

part 'map_suggest_api.g.dart';

/// Mapy.com autocomplete (suggest) endpoint.
@RestApi()
abstract class MapSuggestApi {
  factory MapSuggestApi(Dio dio, {String? baseUrl}) = _MapSuggestApi;

  @GET(MapSearchConstants.suggestPath)
  Future<MapSuggestResponseDto> suggest(
    @Queries() Map<String, dynamic> queries, {
    @CancelRequest() CancelToken? cancelToken,
  });
}
