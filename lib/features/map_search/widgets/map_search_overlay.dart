import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_provider.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_result_list.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_status.dart';
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
    this.status,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final MapSearchState state;
  final String hintText;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;
  final ValueChanged<MapSearchResult> onResultTap;

  /// Advisory status attached under the field (offline / empty map). Shown only
  /// while the field is idle — once focused, the suggestion dropdown owns the
  /// space below the input instead.
  final MapSearchStatus? status;

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

    // The attached status strip only makes sense while the field is idle; once
    // focused, the suggestion dropdown takes the space under the input.
    final showStatus = status != null && !focusNode.hasFocus;
    final animDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 200);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Frosted-glass search pill (zadání §5). The field is the app's primary
        // input, so it uses the full 16px body size (M3 search-bar scale) and
        // the AA-safe [textHint] for the placeholder — neutral500 washed out to
        // ~1.8:1 over the glass on pale map tiles.
        GlassSurface(
          // Zero padding: the input row and the attached status strip each carry
          // their own insets, so the strip can span full width under a hairline.
          padding: EdgeInsets.zero,
          child: AnimatedSize(
            duration: animDuration,
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
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
                      // Trailing slot: a platform activity indicator while a
                      // query is in flight, otherwise a clear/dismiss button.
                      // The button shows whenever the field is focused (even
                      // when empty) or holds text: tapping it clears the text,
                      // or — when already empty — closes the keyboard.
                      if (searchResults.isLoading)
                        Padding(
                          padding: const EdgeInsets.only(right: 13),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                colors.textHint,
                              ),
                            ),
                          ),
                        )
                      else if (focusNode.hasFocus || state.query.isNotEmpty)
                        // Full 44×44 hit target (Apple HIG minimum) with an
                        // explicit label for screen readers, since the glyph's
                        // meaning flips between clear and dismiss.
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
                // The advisory status, attached under the input — grows the
                // search pill into a card while idle, and crossfades between
                // offline / empty / nothing.
                AnimatedSwitcher(
                  duration: animDuration,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: showStatus
                      ? _SearchStatusStrip(
                          key: ValueKey(status!.id),
                          status: status!,
                        )
                      : const SizedBox(
                          width: double.infinity,
                          key: ValueKey('no-status'),
                        ),
                ),
              ],
            ),
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

/// The advisory status strip attached under the search field (see
/// [MapSearchStatus]): a hairline divider, a tinted leading icon (or spinner)
/// and the title/message — subordinate to the input above, but with an accent
/// that lets it read as a status rather than a second search bar.
class _SearchStatusStrip extends StatelessWidget {
  const _SearchStatusStrip({required this.status, super.key});

  final MapSearchStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Semantics(
      container: true,
      liveRegion: true,
      label: '${status.title}. ${status.message}',
      child: DecoratedBox(
        // Hairline separating the status zone from the input above it.
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: colors.neutral900.withValues(alpha: 0.08)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: status.accent.withValues(alpha: 0.14),
                    shape: const CircleBorder(),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: status.busy
                          ? SizedBox(
                              key: const ValueKey('busy'),
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  status.accent,
                                ),
                              ),
                            )
                          : Icon(
                              status.icon,
                              key: ValueKey(status.icon.codePoint),
                              size: 18,
                              color: status.accent,
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.title,
                      style: text.title2.copyWith(color: colors.neutral900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      status.message,
                      style: text.body2.copyWith(color: colors.neutral700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
