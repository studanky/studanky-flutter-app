import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/features/example_feature/entities/example_item_entity.dart';
import 'package:studanky_flutter_app/features/example_feature/providers/example_feature_repository_provider.dart';

part 'example_feature_provider.freezed.dart';

@freezed
abstract class ExampleFeatureState with _$ExampleFeatureState {
  const factory ExampleFeatureState({
    @Default(AsyncValue<List<ExampleItemEntity>>.loading())
    AsyncValue<List<ExampleItemEntity>> items,
    @Default('') String searchQuery,
  }) = _ExampleFeatureState;
}

final exampleFeatureProvider =
    NotifierProvider.autoDispose<ExampleFeatureNotifier, ExampleFeatureState>(
      ExampleFeatureNotifier.new,
    );

class ExampleFeatureNotifier extends Notifier<ExampleFeatureState> {
  final _logger = Logger('ExampleFeatureNotifier');

  @override
  ExampleFeatureState build() {
    Future.microtask(() {
      if (state.searchQuery.isNotEmpty || !state.items.isLoading) {
        return;
      }

      loadItems();
    });
    return const ExampleFeatureState();
  }

  Future<void> loadItems({String query = ''}) async {
    _logger.fine('Loading items with query "$query"');

    state = state.copyWith(
      searchQuery: query,
      items: const AsyncValue.loading(),
    );

    try {
      final repository = ref.read(exampleFeatureRepositoryProvider);
      final items = await repository.fetchItems(
        query: query.isEmpty ? null : query,
      );

      state = state.copyWith(items: AsyncValue.data(items));
      _logger.fine('Loaded ${items.length} items');
    } catch (error, stackTrace) {
      _logger.severe('loadItems error', error, stackTrace);
      state = state.copyWith(items: AsyncValue.error(error, stackTrace));
    }
  }

  Future<void> refresh() {
    return loadItems(query: state.searchQuery);
  }
}
