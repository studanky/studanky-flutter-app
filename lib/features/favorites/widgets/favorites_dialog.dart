import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/shapes.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/app_dialog_card.dart';
import 'package:studanky_flutter_app/core/widgets/app_state_view.dart';
import 'package:studanky_flutter_app/core/widgets/blurred_dialog.dart';
import 'package:studanky_flutter_app/core/widgets/scroll_edge_effect.dart';
import 'package:studanky_flutter_app/features/favorites/providers/favorites_provider.dart';
import 'package:studanky_flutter_app/features/favorites/widgets/swipe_to_delete_tile.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/utils/spring_formatters.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/status_visuals.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Opens the favourites list as an iOS-style floating dialog over a blurred
/// backdrop (a bottom sheet is reserved for the spring detail — zadání §9).
/// Resolves with the spring the user tapped, or null if dismissed.
Future<SpringMarkerEntity?> showFavoritesDialog(BuildContext context) {
  return showBlurredDialog<SpringMarkerEntity>(
    context: context,
    child: const _FavoritesCard(),
  );
}

class _FavoritesCard extends StatelessWidget {
  const _FavoritesCard();

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;

    return AppDialogCard(
      icon: Icons.bookmark_rounded,
      iconColor: colors.saved,
      title: context.l10n.favorites_sheet_title,
      dividerUnderHeader: true,
      maxHeightFactor: 0.66,
      child: const _FavoritesBody(),
    );
  }
}

/// Favourite rows support the iOS-style destructive swipe from trailing edge.
/// Each row keeps its own drag state so only the rounded tile moves.
class _FavoritesBody extends ConsumerWidget {
  const _FavoritesBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(favoritesControllerProvider);

    if (items.isEmpty) return const _EmptyState();

    return ScrollEdgeEffect(
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        itemCount: items.length,
        itemBuilder: (context, index) => _FavoriteTile(spring: items[index]),
      ),
    );
  }
}

class _FavoriteTile extends ConsumerWidget {
  const _FavoriteTile({required this.spring});

  final SpringMarkerEntity spring;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = Styles.appColors;
    final config = ref.watch(platformConfigControllerProvider);
    final visual = headerStatusVisual(
      config.iconFor(spring.status.wireValue, spring.statusUpdatedAt),
      colors,
      l10n,
    );
    final updatedAt = spring.statusUpdatedAt;
    final subtitle = updatedAt == null
        ? visual.label
        : '${visual.label} · ${SpringFormatters.relativeAge(l10n, updatedAt)}';

    Future<void> removeFavorite() => ref
        .read(favoritesControllerProvider.notifier)
        .remove(spring.documentId);

    return SwipeToDeleteTile(
      key: ValueKey('favorite-${spring.documentId}'),
      deleteSemanticLabel: l10n.favorites_remove,
      onDelete: removeFavorite,
      child: _FavoriteTileSurface(
        spring: spring,
        visual: visual,
        subtitle: subtitle,
      ),
    );
  }
}

class _FavoriteTileSurface extends StatelessWidget {
  const _FavoriteTileSurface({
    required this.spring,
    required this.visual,
    required this.subtitle,
  });

  final SpringMarkerEntity spring;
  final StatusVisual visual;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Material(
      color: colors.onNeutral,
      shape: squircleBorder(kRadiusControl),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(spring),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            children: [
              _FavoriteStatusBadge(visual: visual),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spring.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.title2.copyWith(color: colors.neutral900),
                    ),
                    const SizedBox(height: 3),
                    // neutral700: the status + age is the app's key data point
                    // (spec §3 — data freshness); neutral500 read at ~2.2:1.
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.body2.copyWith(
                        fontSize: 12,
                        color: colors.neutral700,
                      ),
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

class _FavoriteStatusBadge extends StatelessWidget {
  const _FavoriteStatusBadge({required this.visual});

  final StatusVisual visual;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: visual.color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(visual.icon, color: visual.color, size: 20),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppStateView(
      icon: Icons.bookmark_border_rounded,
      title: l10n.favorites_empty_title,
      message: l10n.favorites_empty_message,
    );
  }
}
