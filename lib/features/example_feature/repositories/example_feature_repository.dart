import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/utils/api_guard.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/example_feature/data/example_api.dart';
import 'package:studanky_flutter_app/features/example_feature/entities/example_item_entity.dart';
import 'package:studanky_flutter_app/features/example_feature/mappers/example_item_mapper.dart';

part 'example_feature_repository.g.dart';

abstract class ExampleFeatureRepository {
  Future<ApiResult<List<ExampleItemEntity>>> fetchItems({String? query});
}

class ExampleFeatureRepositoryImpl implements ExampleFeatureRepository {
  ExampleFeatureRepositoryImpl(this._api);

  final ExampleApi _api;

  @override
  Future<ApiResult<List<ExampleItemEntity>>> fetchItems({String? query}) {
    final queries = <String, dynamic>{
      if (query != null && query.isNotEmpty) 'q': query,
    };

    return guardApiCall(() async {
      final response = await _api.fetchItems(queries);
      return response.data
          .map(ExampleItemMapper.fromDto)
          .toList(growable: false);
    });
  }
}

@riverpod
ExampleFeatureRepository exampleFeatureRepository(Ref ref) =>
    ExampleFeatureRepositoryImpl(ref.watch(exampleApiProvider));
