import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/async_value_builder.dart';
import 'package:studanky_flutter_app/features/example_feature/entities/example_item_entity.dart';
import 'package:studanky_flutter_app/features/example_feature/example_feature_content.dart';
import 'package:studanky_flutter_app/features/example_feature/providers/example_feature_provider.dart';

class ExampleFeaturePage extends ConsumerWidget {
  const ExampleFeaturePage({
    super.key,
    this.title = 'Example Feature',
    this.onItemSelected,
    this.onCreateItem,
  });

  final String title;
  final ValueChanged<ExampleItemEntity>? onItemSelected;
  final VoidCallback? onCreateItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exampleFeatureProvider);
    final notifier = ref.read(exampleFeatureProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Styles.appColors.primaryMain,
        foregroundColor: Styles.appColors.onPrimary,
        actions: [
          if (onCreateItem != null)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onCreateItem,
              tooltip: 'Create item',
            ),
        ],
      ),
      body: AsyncValueBuilder<List<ExampleItemEntity>>(
        asyncValue: state.items,
        onRefresh: notifier.refresh,
        data: (items) => ExampleFeatureContent(
          items: items,
          onItemTap: onItemSelected ?? (_) {},
          onRefresh: notifier.refresh,
        ),
      ),
    );
  }
}
