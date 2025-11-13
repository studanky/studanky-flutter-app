import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/api/clients/api_client.dart';
import 'package:studanky_flutter_app/features/example_feature/services/example_feature_api_service.dart';

final exampleFeatureApiServiceProvider =
    Provider.autoDispose<ExampleFeatureApiService>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return ExampleFeatureApiService(apiClient);
    });
