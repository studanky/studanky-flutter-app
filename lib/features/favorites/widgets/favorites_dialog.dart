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
    final count = ref.watch(
      favoritesControllerProvider.select((f) => f.length),
    );
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
              _Header(count: count),
              Divider(height: 1, color: colors.neutral200),
              const Flexible(child: _FavoritesBody()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated favourites list: removals (and additions) play a size+fade
/// transition via [AnimatedList] instead of the list snapping to a new height.
class _FavoritesBody extends ConsumerStatefulWidget {
  const _FavoritesBody();

  @override
  ConsumerState<_FavoritesBody> createState() => _FavoritesBodyState();
}

class _FavoritesBodyState extends ConsumerState<_FavoritesBody> {
  final _listKey = GlobalKey<AnimatedListState>();
  static const _animDuration = Duration(milliseconds: 260);

  late List<SpringMarkerEntity> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(ref.read(favoritesControllerProvider));
  }

  /// Diffs the mirror against the provider's latest list and drives the
  /// matching insert/remove animations.
  void _sync(List<SpringMarkerEntity> next) {
    for (var i = _items.length - 1; i >= 0; i--) {
      final item = _items[i];
      if (!next.any((e) => e.documentId == item.documentId)) {
        _items.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => _animatedTile(item, animation),
          duration: _animDuration,
        );
      }
    }
    for (var i = 0; i < next.length; i++) {
      final item = next[i];
      if (!_items.any((e) => e.documentId == item.documentId)) {
        final insertAt = i.clamp(0, _items.length);
        _items.insert(insertAt, item);
        _listKey.currentState?.insertItem(insertAt, duration: _animDuration);
      }
    }
    // Toggle between the empty state and the list once the model changed.
    setState(() {});
  }

  Widget _animatedTile(SpringMarkerEntity spring, Animation<double> animation) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
    return SizeTransition(
      sizeFactor: curved,
      child: FadeTransition(
        opacity: curved,
        child: _FavoriteTile(spring: spring),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(favoritesControllerProvider, (_, next) => _sync(next));

    if (_items.isEmpty) return const _EmptyState();

    return AnimatedList(
      key: _listKey,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      initialItemCount: _items.length,
      itemBuilder: (context, index, animation) =>
          _animatedTile(_items[index], animation),
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
