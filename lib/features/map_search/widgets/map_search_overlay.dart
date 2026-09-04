import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_provider.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_field.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_result_list.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_status.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

class MapSearchOverlay extends StatelessWidget {
  const MapSearchOverlay({
    required this.controller,
    required this.focusNode,
    required this.state,
    required this.hintText,
    required this.onQueryChanged,
    required this.onClear,
    required this.onResultTap,
    this.status,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final MapSearchState state;
  final String hintText;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;
  final ValueChanged<MapSearchResult> onResultTap;
  final MapSearchStatus? status;

  @override
  Widget build(BuildContext context) {
    final searchResults = state.searchResults;
    final results = searchResults.value ?? const <MapSearchResult>[];
    final showSuggestions = focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MapSearchField(
          controller: controller,
          focusNode: focusNode,
          state: state,
          hintText: hintText,
          onQueryChanged: onQueryChanged,
          onClear: onClear,
          status: status,
        ),
        if (searchResults.hasError && showSuggestions)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GlassSurface(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 18,
                    color: Styles.appColors.errorText,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      context.l10n.map_search_error,
                      style: Styles.textStyles.body2.copyWith(
                        color: Styles.appColors.neutral900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (results.isNotEmpty && showSuggestions)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: MapSearchResultList(results: results, onTap: onResultTap),
          ),
      ],
    );
  }
}
