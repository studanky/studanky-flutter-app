import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_container.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_provider.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_result_list.dart';

class MapSearchOverlay extends StatelessWidget {
  const MapSearchOverlay({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.state,
    required this.hintText,
    required this.onQueryChanged,
    required this.onClear,
    required this.onResultTap,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final MapSearchState state;
  final String hintText;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;
  final ValueChanged<MapSearchResult> onResultTap;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final searchResults = state.searchResults;
    final results = searchResults.value ?? const <MapSearchResult>[];
    final errorMessage = searchResults.hasError
        ? 'Unable to search at the moment.'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Frosted-glass search pill (zadání §5).
        GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Icon(Icons.search_rounded, size: 20, color: colors.primaryMain),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: onQueryChanged,
                  textInputAction: TextInputAction.search,
                  style: Styles.textStyles.body2.copyWith(
                    color: colors.neutral900,
                  ),
                  cursorColor: colors.primaryMain,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: Styles.textStyles.body2.copyWith(
                      color: colors.neutral500,
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              // Trailing slot: a platform activity indicator while a query is
              // in flight, otherwise a clear/dismiss button. The button shows
              // whenever the field is focused (even when empty) or holds text:
              // tapping it clears the text, or — when already empty — closes
              // the keyboard. This replaces the former tap-outside dismissal.
              if (searchResults.isLoading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(colors.neutral500),
                  ),
                )
              else if (focusNode.hasFocus || state.query.isNotEmpty)
                InkResponse(
                  onTap: () {
                    if (state.query.isNotEmpty) {
                      onClear();
                    } else {
                      focusNode.unfocus();
                    }
                  },
                  radius: 18,
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: colors.neutral500,
                  ),
                ),
            ],
          ),
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
