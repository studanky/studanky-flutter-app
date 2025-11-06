import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/example_feature/entities/example_item_entity.dart';

class ExampleItemTile extends StatelessWidget {
  const ExampleItemTile({super.key, required this.item, this.onTap});

  final ExampleItemEntity item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat.yMMMd();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Styles.appColors.onSecondary,
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Styles.appColors.primary900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Styles.appColors.neutral700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Created on ${formatter.format(item.createdAt)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Styles.appColors.neutral500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
