import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/blurred_dialog.dart';
import 'package:studanky_flutter_app/features/favorites/providers/favorites_provider.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/utils/spring_formatters.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/status_visuals.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Max width of the floating card on large screens (tablets).
const double _maxCardWidth = 460;

/// Opens the favourites list as an iOS-style floating dialog over a blurred
/// backdrop (a bottom sheet is reserved for the spring detail — zadání §9).
/// Resolves with the spring the user tapped, or null if dismissed.
Future<SpringMarkerEntity?> showFavoritesDialog(BuildContext context) {
  return showBlurredDialog<SpringMarkerEntity>(
    context: context,
    child: const _FavoritesCard(),
  );
}

class _FavoritesCard extends ConsumerWidget {
  const _FavoritesCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Styles.appColors;
    final favorites = ref.watch(favoritesControllerProvider);
    final maxHeight = MediaQuery.of(context).size.height * 0.66;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _maxCardWidth),
      child: Material(
        color: colors.onNeutral,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(count: favorites.length),
              Divider(height: 1, color: colors.neutral200),
              if (favorites.isEmpty)
                const Flexible(child: _EmptyState())
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: favorites.length,
                    separatorBuilder: (context, _) =>
                        Divider(height: 1, color: colors.neutral200),
                    itemBuilder: (context, index) =>
                        _FavoriteTile(spring: favorites[index]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 14),
      child: Row(
        children: [
          Icon(Icons.favorite_rounded, size: 20, color: colors.primaryMain),
          const SizedBox(width: 10),
          Text(
            context.l10n.favorites_sheet_title,
            style: text.h5.copyWith(color: colors.neutral900),
          ),
          if (count > 0) ...[
            const SizedBox(width: 8),
            Text(
              '$count',
              style: text.body1.copyWith(color: colors.neutral500),
            ),
          ],
          const Spacer(),
          IconButton(
            icon: Icon(Icons.close_rounded, color: colors.neutral700),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
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
    final text = Styles.textStyles;
    final config = ref.watch(platformConfigControllerProvider);
    final visual = headerStatusVisual(
      config.iconFor(spring.status.wireValue, spring.statusUpdatedAt),
      colors,
      l10n,
    );
    final updatedAt = spring.statusUpdatedAt;

    return ListTile(
      onTap: () => Navigator.of(context).pop(spring),
      leading: Icon(visual.icon, color: visual.color),
      title: Text(
        spring.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: text.title2.copyWith(color: colors.neutral900),
      ),
      subtitle: updatedAt == null
          ? null
          : Text(
              SpringFormatters.relativeAge(l10n, updatedAt),
              style: text.body2.copyWith(color: colors.neutral700),
            ),
      trailing: IconButton(
        icon: Icon(Icons.bookmark_remove_outlined, color: colors.neutral500),
        tooltip: l10n.favorites_remove,
        onPressed: () => ref
            .read(favoritesControllerProvider.notifier)
            .remove(spring.documentId),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bookmark_border_rounded,
            size: 48,
            color: colors.neutral500,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.favorites_empty_title,
            style: text.title1.copyWith(color: colors.neutral900),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.favorites_empty_message,
            textAlign: TextAlign.center,
            style: text.body2.copyWith(color: colors.neutral700),
          ),
        ],
      ),
    );
  }
}
