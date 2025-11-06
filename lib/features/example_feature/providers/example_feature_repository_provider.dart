import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/features/example_feature/providers/example_feature_api_provider.dart';
import 'package:studanky_flutter_app/features/example_feature/repositories/example_feature_repository.dart';

final exampleFeatureRepositoryProvider =
    Provider.autoDispose<ExampleFeatureRepository>((ref) {
      final apiService = ref.watch(exampleFeatureApiServiceProvider);
      return ExampleFeatureRepositoryImpl(apiService);
    });
