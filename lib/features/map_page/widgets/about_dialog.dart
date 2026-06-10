import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/blurred_dialog.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/marker.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';

/// Max width of the floating card on large screens.
const double _maxCardWidth = 460;

/// Opens the "About / help" dialog over a blurred backdrop (iOS-style, not a
/// bottom sheet — those are reserved for the spring detail): what the app
/// shows, what each marker state means, and the potability disclaimer
/// (zadání §10, §12).
Future<void> showAppAboutDialog(BuildContext context) {
  return showBlurredDialog<void>(context: context, child: const _AboutCard());
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final maxHeight = MediaQuery.of(context).size.height * 0.8;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _maxCardWidth),
      child: Material(
        color: colors.onNeutral,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.water_drop_rounded, color: colors.primaryMain),
                    const SizedBox(width: 8),
                    Text(
                      'Studánky',
                      style: text.h5.copyWith(color: colors.neutral900),
                    ),
                    const Spacer(),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.close_rounded, color: colors.neutral700),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Aplikace na mapě ukazuje, zda ve studánce hlášeně teče voda '
                  'a jak čerstvá je informace. Trasu si naplánujte ve své '
                  'mapové aplikaci přes tlačítko Navigovat v detailu studánky.',
                  style: text.body2.copyWith(color: colors.neutral700),
                ),
                const SizedBox(height: 24),
                Text(
                  'Význam značek',
                  style: text.title2.copyWith(color: colors.neutral900),
                ),
                const SizedBox(height: 12),
                const _LegendRow(icon: SpringIcon.flowing, label: 'Teče voda'),
                const _LegendRow(
                  icon: SpringIcon.notFlowing,
                  label: 'Neteče voda',
                ),
                const _LegendRow(
                  icon: SpringIcon.stale,
                  label:
                      'Neaktuální — poslední záznam je starší než práh '
                      'čerstvosti',
                ),
                const _LegendRow(
                  icon: SpringIcon.unknown,
                  label: 'Neznámý stav — žádný záznam',
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.secondaryBeige,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 20,
                        color: colors.secondaryVariant1,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Aplikace informuje pouze o tom, zda je ve studánce '
                          'hlášený tok vody. Neověřuje zdravotní nezávadnost '
                          'ani pitnost vody. Užívání vody je na vlastní '
                          'odpovědnost.',
                          style: text.body2.copyWith(color: colors.neutral800),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.icon, required this.label});

  final SpringIcon icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpringMarkerIcon(icon: icon, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                label,
                style: Styles.textStyles.body2.copyWith(
                  color: colors.neutral700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
