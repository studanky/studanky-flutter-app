import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Max width on large screens (tablets); below this it stretches to the
/// available width. Matches the detail sheet so the two read as one family.
const double _maxSheetWidth = 640;

/// Asks the user which installed maps app to open the spring in, and returns
/// the chosen one (or null if dismissed). A pure picker: it neither launches
/// the app nor reports errors — the caller owns that with its stable context.
///
/// Only meant for 2+ maps; the caller shortcuts the 0/1 cases so the user never
/// sees an empty or single-item list. Mirrors the detail sheet's full-bleed
/// frosted backdrop (no dim) so it reads as the same glass language.
Future<AvailableMap?> showMapPickerSheet(
  BuildContext context, {
  required List<AvailableMap> maps,
}) {
  final topInset = MediaQuery.viewPaddingOf(context).top;
  return showModalBottomSheet<AvailableMap>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    builder: (sheetContext) {
      return Stack(
        children: [
          Positioned.fill(
            child: _PickerBackdrop(
              onTapOutside: () => Navigator.of(sheetContext).maybePop(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxSheetWidth),
              child: Padding(
                padding: EdgeInsets.only(top: topInset),
                child: _MapPickerSheet(maps: maps),
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// Full-bleed frosted backdrop whose blur eases in/out with the sheet's
/// transition, plus tap-to-dismiss for the area above the sheet. Shared look
/// with the spring detail sheet's backdrop.
class _PickerBackdrop extends StatelessWidget {
  const _PickerBackdrop({required this.onTapOutside});

  final VoidCallback onTapOutside;

  static const double _maxSigma = kBackdropBlurSigma;

  @override
  Widget build(BuildContext context) {
    final animation =
        ModalRoute.of(context)?.animation ??
        const AlwaysStoppedAnimation(1.0);

    return GestureDetector(
      onTap: onTapOutside,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final t = Curves.easeOut.transform(animation.value.clamp(0.0, 1.0));
          final sigma = _maxSigma * t;
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

/// The card itself: grabber, title and a tappable row per installed maps app.
/// Content-sized (never full-height); long lists scroll within the safe area.
class _MapPickerSheet extends StatelessWidget {
  const _MapPickerSheet({required this.maps});

  final List<AvailableMap> maps;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(kRadiusCard)),
      child: Material(
        color: colors.background,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Grabber(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
                child: Text(
                  context.l10n.spring_detail_open_in_app,
                  style: text.title1.copyWith(color: colors.neutral900),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 8),
                  itemCount: maps.length,
                  itemBuilder: (context, index) => _MapTile(map: maps[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One maps app: its official glyph, its name, and an "opens elsewhere" hint.
class _MapTile extends StatelessWidget {
  const _MapTile({required this.map});

  final AvailableMap map;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(map),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(kRadiusChip),
                child: SvgPicture.asset(
                  map.icon,
                  width: 38,
                  height: 38,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  map.mapName,
                  style: text.body1.copyWith(color: colors.neutral900),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              // neutral700: the arrow signals "opens externally" — meaningful,
              // so it needs icon-grade contrast (≥3:1).
              Icon(
                Icons.arrow_outward_rounded,
                size: 18,
                color: colors.neutral700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The drag handle, identical to the detail sheet's grabber.
class _Grabber extends StatelessWidget {
  const _Grabber();

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: colors.neutral300,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
