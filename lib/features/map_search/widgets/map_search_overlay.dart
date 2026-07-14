import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_provider.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_result_list.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

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
        ? context.l10n.map_search_error
        : null;
    // Map-app convention (Google/Apple/Mapy.cz): suggestions belong to active
    // text entry. Touching the map unfocuses the field, which hides the
    // dropdown/error but keeps the typed query as context — refocusing the
    // field brings the cached suggestions straight back.
    final showOverlays = focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Frosted-glass search pill (zadání §5). The field is the app's primary
        // input, so it uses the full 16px body size (M3 search-bar scale) and
        // the AA-safe [textHint] for the placeholder — neutral500 washed out to
        // ~1.8:1 over the glass on pale map tiles.
        GlassSurface(
          padding: const EdgeInsets.only(left: 14, right: 4),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 20,
                color: colors.primaryInteractive,
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: onQueryChanged,
                  textInputAction: TextInputAction.search,
                  style: Styles.textStyles.body1.copyWith(
                    color: colors.neutral900,
                  ),
                  cursorColor: colors.primaryMain,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: Styles.textStyles.body1.copyWith(
                      color: colors.textHint,
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
                Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(colors.textHint),
                    ),
                  ),
                )
              else if (focusNode.hasFocus || state.query.isNotEmpty)
                // Full 44×44 hit target (Apple HIG minimum; the glyph alone was
                // an 18px target) with an explicit label for screen readers,
                // since the glyph's meaning flips between clear and dismiss.
                Semantics(
                  button: true,
                  label: state.query.isNotEmpty
                      ? context.l10n.map_search_clear
                      : context.l10n.map_search_close,
                  child: InkResponse(
                    onTap: () {
                      if (state.query.isNotEmpty) {
                        onClear();
                      } else {
                        focusNode.unfocus();
                      }
                    },
                    radius: 22,
                    child: SizedBox.square(
                      dimension: 44,
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: colors.textHint,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (errorMessage != null && showOverlays)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            // Same glass family as the results dropdown — the bare text used to
            // sit straight on the map tiles and disappeared over dark forest.
            child: GlassSurface(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 18,
                    color: colors.errorText,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: Styles.textStyles.body2.copyWith(
                        color: colors.neutral900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (results.isNotEmpty && showOverlays)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: MapSearchResultList(results: results, onTap: onResultTap),
          ),
      ],
    );
  }
}
