import 'package:dio/dio.dart';
import 'package:studanky_flutter_app/core/config/mapy_config.dart';
import 'package:studanky_flutter_app/features/map/models/map_suggest_query.dart';
import 'package:studanky_flutter_app/features/map/models/mapy_suggest_response.dart';

class MapySuggestApiClient {
  MapySuggestApiClient({required this.dio, required this.apiKey});

  final Dio dio;
  final String apiKey;

  Future<MapySuggestResponse> fetch(MapySuggestQuery query) async {
    final response = await dio.get<Map<String, dynamic>>(
      MapyConfig.suggestPath,
      queryParameters: query.toQueryParameters(apiKey),
    );

    final data = response.data;
    if (data == null) {
      return const MapySuggestResponse();
    }

    return MapySuggestResponse.fromJson(data);
  }
}
