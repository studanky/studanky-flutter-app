import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/example_feature/entities/example_item_entity.dart';
import 'package:studanky_flutter_app/features/example_feature/repositories/example_feature_repository.dart';

part 'example_feature_provider.freezed.dart';
part 'example_feature_provider.g.dart';

@freezed
abstract class ExampleFeatureState with _$ExampleFeatureState {
  const factory ExampleFeatureState({
    @Default(AsyncValue<List<ExampleItemEntity>>.loading())
    AsyncValue<List<ExampleItemEntity>> items,
    @Default('') String searchQuery,
  }) = _ExampleFeatureState;
}

@riverpod
class ExampleFeature extends _$ExampleFeature {
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

    final result = await ref
        .read(exampleFeatureRepositoryProvider)
        .fetchItems(query: query.isEmpty ? null : query);

    state = switch (result) {
      Success(:final data) => state.copyWith(items: AsyncValue.data(data)),
      Failure(:final exception) => state.copyWith(
        items: AsyncValue.error(exception, StackTrace.current),
      ),
    };

    if (result case Failure(:final exception)) {
      _logger.severe('loadItems error', exception);
    } else {
      _logger.fine('Loaded ${result.dataOrNull?.length ?? 0} items');
    }
  }

  Future<void> refresh() => loadItems(query: state.searchQuery);
}
