import 'package:dio/dio.dart';
import 'package:studanky_flutter_app/features/map_search/constants/map_search_constants.dart';
import 'package:studanky_flutter_app/features/map_search/dtos/map_suggest_query_dto.dart';
import 'package:studanky_flutter_app/features/map_search/dtos/map_suggest_response_dto.dart';

class MapSuggestApiClient {
  MapSuggestApiClient({required this.dio, required this.apiKey});

  final Dio dio;
  final String apiKey;

  Future<MapSuggestResponseDto> fetch(MapySuggestQueryDto query) async {
    final response = await dio.get<Map<String, dynamic>>(
      MapSearchConstants.suggestPath,
      queryParameters: query.toQueryParameters(apiKey),
    );

    final data = response.data;
    if (data == null) {
      return const MapSuggestResponseDto();
    }

    return MapSuggestResponseDto.fromJson(data);
  }
}
