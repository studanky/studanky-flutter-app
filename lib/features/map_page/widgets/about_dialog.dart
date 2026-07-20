import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:studanky_flutter_app/core/legal/legal_config.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/shapes.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/app_dialog_card.dart';
import 'package:studanky_flutter_app/core/widgets/blurred_dialog.dart';
import 'package:studanky_flutter_app/core/widgets/scroll_edge_effect.dart';
import 'package:studanky_flutter_app/features/legal/widgets/legal_link_button.dart';
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
              _SectionTitle(l10n.about_project_title),
              const SizedBox(height: 10),
              Text(
                l10n.about_dialog_body,
                style: text.body2.copyWith(
                  color: colors.neutral700,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              _SectionTitle(l10n.about_dialog_legend_title),
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
                decoration: ShapeDecoration(
                  color: colors.secondaryBeige,
                  shape: squircleBorder(kRadiusControl),
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
              const SizedBox(height: 24),
              _SectionTitle(l10n.about_legal_documents_title),
              const SizedBox(height: 10),
              Text(
                l10n.about_legal_documents_body,
                style: text.body2.copyWith(color: colors.neutral700),
              ),
              const SizedBox(height: 6),
              LegalLinkButton(
                icon: Icons.gavel_rounded,
                label: l10n.legal_link_terms,
                uri: LegalConfig.termsUrl,
              ),
              LegalLinkButton(
                icon: Icons.privacy_tip_rounded,
                label: l10n.legal_link_privacy,
                uri: LegalConfig.privacyUrl,
              ),
              LegalLinkButton(
                icon: Icons.dataset_linked_rounded,
                label: l10n.legal_link_data_sources,
                uri: LegalConfig.dataSourcesUrl,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () async {
                    if (!context.mounted) return;
                    showLicensePage(
                      context: context,
                      applicationName: l10n.about_dialog_title,
                    );
                  },
                  icon: const Icon(Icons.description_rounded, size: 18),
                  label: Text(l10n.about_legal_open_source_licenses),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.primaryInteractive,
                    textStyle: text.button,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 6,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  final packageInfo = snapshot.data;
                  final version = packageInfo == null
                      ? l10n.about_legal_version_loading
                      : packageInfo.version;

                  return Text(
                    l10n.about_legal_version_line(version),
                    style: text.body2.copyWith(
                      fontSize: 12,
                      color: colors.textHint,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Styles.textStyles.title1.copyWith(
        color: Styles.appColors.neutral900,
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
