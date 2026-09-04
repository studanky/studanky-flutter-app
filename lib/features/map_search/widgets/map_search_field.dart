import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_provider.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_status.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_status_strip.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

class MapSearchField extends StatelessWidget {
  const MapSearchField({
    required this.controller,
    required this.focusNode,
    required this.state,
    required this.hintText,
    required this.onQueryChanged,
    required this.onClear,
    this.status,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final MapSearchState state;
  final String hintText;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;
  final MapSearchStatus? status;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final searchResults = state.searchResults;
    final showStatus = status != null && !focusNode.hasFocus;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 200);

    return GlassSurface(
      padding: EdgeInsets.zero,
      child: AnimatedSize(
        duration: duration,
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
                    color: colors.neutral700,
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
                  if (searchResults.isLoading)
                    Padding(
                      padding: const EdgeInsets.only(right: 13),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            colors.primaryMain,
                          ),
                        ),
                      ),
                    )
                  else if (focusNode.hasFocus || state.query.isNotEmpty)
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
            AnimatedSwitcher(
              duration: duration,
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: showStatus
                  ? MapSearchStatusStrip(
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
    );
  }
}
