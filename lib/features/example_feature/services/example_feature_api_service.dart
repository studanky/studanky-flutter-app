import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/services/base_api_service.dart';
import 'package:studanky_flutter_app/features/example_feature/bos/example_item_bo.dart';

class ExampleFeatureApiService extends BaseApiService {
  ExampleFeatureApiService(super.apiClient);

  Future<List<ExampleItemBO>> fetchItems({
    Map<String, dynamic>? queryParameters,
  }) {
    return getList(
      ApiConfig.exampleItemsEndpoint,
      queryParameters: queryParameters,
      fromJson: ExampleItemBO.fromJson,
    );
  }
}
