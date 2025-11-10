import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/features/example_feature/entities/example_item_entity.dart';
import 'package:studanky_flutter_app/features/example_feature/widgets/example_item_tile.dart';

class ExampleFeatureContent extends StatelessWidget {
  const ExampleFeatureContent({
    super.key,
    required this.items,
    required this.onItemTap,
    required this.onRefresh,
  });

  final List<ExampleItemEntity> items;
  final ValueChanged<ExampleItemEntity> onItemTap;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: items.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [SizedBox(height: 160), _EmptyState()],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return ExampleItemTile(
                  item: item,
                  onTap: () => onItemTap(item),
                );
              },
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, color: theme.colorScheme.secondary, size: 48),
          const SizedBox(height: 16),
          Text(
            'No items yet',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Use the add button to create your first item or pull to refresh.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
