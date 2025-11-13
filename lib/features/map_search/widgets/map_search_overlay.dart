import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_provider.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_result_list.dart';

class MapSearchOverlay extends StatelessWidget {
  const MapSearchOverlay({
    super.key,
    required this.controller,
    required this.state,
    required this.hintText,
    required this.onQueryChanged,
    required this.onClear,
    required this.onResultTap,
  });

  final TextEditingController controller;
  final MapSearchState state;
  final String hintText;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;
  final ValueChanged<MapSearchResult> onResultTap;

  @override
  Widget build(BuildContext context) {
    final searchResults = state.searchResults;
    final results = searchResults.value ?? const <MapSearchResult>[];
    final errorMessage = searchResults.hasError
        ? 'Unable to search at the moment.'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(16),
          color: Styles.appColors.neutral200,
          child: TextField(
            controller: controller,
            onChanged: onQueryChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: hintText,
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
        if (searchResults.isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(minHeight: 2),
          ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(errorMessage, style: Styles.textStyles.body1),
          ),
        if (results.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: MapSearchResultList(results: results, onTap: onResultTap),
          ),
      ],
    );
  }
}
