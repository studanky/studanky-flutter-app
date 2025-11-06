import 'package:dio/dio.dart';
import 'package:studanky_flutter_app/features/map_page/map_page_constants.dart';
import 'package:studanky_flutter_app/features/map_page/models/search/map_suggest_query.dart';
import 'package:studanky_flutter_app/features/map_page/models/search/map_suggest_response.dart';

class MapSuggestApiClient {
  MapSuggestApiClient({required this.dio, required this.apiKey});

  final Dio dio;
  final String apiKey;

  Future<MapSuggestResponse> fetch(MapySuggestQuery query) async {
    final response = await dio.get<Map<String, dynamic>>(
      MapPageConstants.mapSearchSuggestPath,
      queryParameters: query.toQueryParameters(apiKey),
    );

    final data = response.data;
    if (data == null) {
      return const MapSuggestResponse();
    }

    return MapSuggestResponse.fromJson(data);
  }
}
