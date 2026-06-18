import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/app_dialog_card.dart';
import 'package:studanky_flutter_app/core/widgets/blurred_dialog.dart';
import 'package:studanky_flutter_app/core/widgets/scroll_edge_effect.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/marker.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

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
    final l10n = context.l10n;

    return AppDialogCard(
      icon: Icons.water_drop_rounded,
      title: l10n.about_dialog_title,
      child: ScrollEdgeEffect(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.about_dialog_body,
                style: text.body2.copyWith(color: colors.neutral700),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.about_dialog_legend_title,
                style: text.title1.copyWith(color: colors.neutral900),
              ),
              const SizedBox(height: 12),
              _LegendRow(
                icon: SpringIcon.flowing,
                label: l10n.about_dialog_legend_flowing,
              ),
              _LegendRow(
                icon: SpringIcon.notFlowing,
                label: l10n.about_dialog_legend_not_flowing,
              ),
              _LegendRow(
                icon: SpringIcon.stale,
                label: l10n.about_dialog_legend_stale,
              ),
              _LegendRow(
                icon: SpringIcon.unknown,
                label: l10n.about_dialog_legend_unknown,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.secondaryBeige,
                  borderRadius: BorderRadius.circular(kRadiusControl),
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
                        l10n.map_potability_disclaimer_body,
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
