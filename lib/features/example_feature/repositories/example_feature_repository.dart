import 'package:studanky_flutter_app/features/example_feature/entities/example_item_entity.dart';
import 'package:studanky_flutter_app/features/example_feature/mappers/example_item_mapper.dart';
import 'package:studanky_flutter_app/features/example_feature/services/example_feature_api_service.dart';

abstract class ExampleFeatureRepository {
  Future<List<ExampleItemEntity>> fetchItems({String? query});
}

class ExampleFeatureRepositoryImpl implements ExampleFeatureRepository {
  ExampleFeatureRepositoryImpl(this._apiService);

  final ExampleFeatureApiService _apiService;

  @override
  Future<List<ExampleItemEntity>> fetchItems({String? query}) async {
    final queryParameters = (query == null || query.isEmpty)
        ? null
        : <String, dynamic>{'q': query};

    final bosList = await _apiService.fetchItems(
      queryParameters: queryParameters,
    );

    return bosList.map(ExampleItemMapper.fromBO).toList(growable: false);
  }
}
