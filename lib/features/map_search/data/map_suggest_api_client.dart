import 'package:dio/dio.dart';
import 'package:studanky_flutter_app/features/map_search/bos/map_suggest_query_bo.dart';
import 'package:studanky_flutter_app/features/map_search/bos/map_suggest_response_bo.dart';
import 'package:studanky_flutter_app/features/map_search/constants/map_search_constants.dart';

class MapSuggestApiClient {
  MapSuggestApiClient({required this.dio, required this.apiKey});

  final Dio dio;
  final String apiKey;

  Future<MapSuggestResponseBO> fetch(MapySuggestQueryBO query) async {
    final response = await dio.get<Map<String, dynamic>>(
      MapSearchConstants.suggestPath,
      queryParameters: query.toQueryParameters(apiKey),
    );

    final data = response.data;
    if (data == null) {
      return const MapSuggestResponseBO();
    }

    return MapSuggestResponseBO.fromJson(data);
  }
}
