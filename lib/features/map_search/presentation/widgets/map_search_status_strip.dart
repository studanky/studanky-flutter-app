import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/map_search/presentation/widgets/map_search_status.dart';

class MapSearchStatusStrip extends StatelessWidget {
  const MapSearchStatusStrip({required this.status, super.key});

  final MapSearchStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = context.appTextStyles;

    return Semantics(
      container: true,
      liveRegion: true,
      label: '${status.title}. ${status.message}',
      child: DecoratedBox(
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
