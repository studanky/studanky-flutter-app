import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';

class MapSearchResultList extends StatelessWidget {
  const MapSearchResultList({
    super.key,
    required this.results,
    required this.onTap,
  });

  final List<MapSearchResult> results;
  final ValueChanged<MapSearchResult> onTap;

  @override
  Widget build(BuildContext context) {
    final height = (results.length * 56.0).clamp(0, 240).toDouble();

    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      color: Styles.appColors.neutral200,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: height,
          minWidth: double.infinity,
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 4),
          shrinkWrap: true,
          itemCount: results.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final result = results[index];
            final subtitle = result.raw?['description'] as String?;
            return ListTile(
              title: Text(result.label),
              subtitle: (subtitle != null && subtitle.isNotEmpty)
                  ? Text(subtitle)
                  : null,
              onTap: () => onTap(result),
            );
          },
        ),
      ),
    );
  }
}
