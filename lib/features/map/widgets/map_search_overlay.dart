import 'package:flutter/material.dart';

import 'package:studanky_flutter_app/features/map/models/map_search_result.dart';
import 'package:studanky_flutter_app/features/map/providers/map_search_providers.dart';
import 'package:studanky_flutter_app/features/map/widgets/map_search_result_list.dart';

/// Search input field with drop-down suggestions rendered above the map.
class MapSearchOverlay extends StatelessWidget {
  const MapSearchOverlay({
    super.key,
    required this.controller,
    required this.state,
    required this.onQueryChanged,
    required this.onClear,
    required this.onResultTap,
  });

  final TextEditingController controller;
  final MapSearchState state;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;
  final ValueChanged<MapSearchResult> onResultTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surface,
          child: TextField(
            controller: controller,
            onChanged: onQueryChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search places',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: state.query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: onClear,
                      icon: const Icon(Icons.clear),
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
        if (state.isSearching)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(minHeight: 2),
          ),
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              state.error!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        if (state.results.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: MapSearchResultList(
              results: state.results,
              onTap: onResultTap,
            ),
          ),
      ],
    );
  }
}
