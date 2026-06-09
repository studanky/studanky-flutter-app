import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/favorites/providers/favorites_provider.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/utils/spring_formatters.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/status_visuals.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Opens the favourites popup and resolves with the spring the user tapped (to
/// center the map on and open its detail), or null if dismissed.
Future<SpringMarkerEntity?> showFavoritesSheet(BuildContext context) {
  return showModalBottomSheet<SpringMarkerEntity>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _FavoritesSheet(),
  );
}

class _FavoritesSheet extends ConsumerWidget {
  const _FavoritesSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Styles.appColors;
    final favorites = ref.watch(favoritesControllerProvider);
    final maxHeight = MediaQuery.of(context).size.height * 0.7;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: ColoredBox(
        color: colors.onNeutral,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _Grabber(),
              _Title(count: favorites.length),
              if (favorites.isEmpty)
                const Flexible(child: _EmptyState())
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 12),
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

class _Title extends StatelessWidget {
  const _Title({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          Text(
            context.l10n.favorites_sheet_title,
            style: text.h5.copyWith(color: colors.neutral900),
          ),
          if (count > 0) ...[
            const SizedBox(width: 8),
            Text('$count', style: text.body1.copyWith(color: colors.neutral500)),
          ],
        ],
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
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bookmark_border_rounded, size: 48, color: colors.neutral500),
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

class _Grabber extends StatelessWidget {
  const _Grabber();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Styles.appColors.neutral300,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
