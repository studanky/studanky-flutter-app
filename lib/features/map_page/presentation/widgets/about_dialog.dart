import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/legal/legal_links.dart';
import 'package:studanky_flutter_app/core/platform/package_app_info_service.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/shapes.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/app_dialog_card.dart';
import 'package:studanky_flutter_app/core/widgets/blurred_dialog.dart';
import 'package:studanky_flutter_app/core/widgets/scroll_edge_effect.dart';
import 'package:studanky_flutter_app/features/legal/widgets/legal_link_button.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/about_section_title.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/spring_legend_row.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Opens the "About / help" dialog over a blurred backdrop (iOS-style, not a
/// bottom sheet — those are reserved for the spring detail): what the app
/// shows, what each marker state means, and the potability disclaimer
/// (zadání §10, §12).
Future<void> showAppAboutDialog(BuildContext context) {
  return showBlurredDialog<void>(context: context, child: const _AboutCard());
}

class _AboutCard extends ConsumerWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final text = context.appTextStyles;
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
              AboutSectionTitle(l10n.about_project_title),
              const SizedBox(height: 10),
              Text(
                l10n.about_dialog_body,
                style: text.body2.copyWith(
                  color: colors.neutral700,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 6),
              LegalLinkButton(
                icon: Icons.public_rounded,
                label: l10n.about_dialog_more_info_link,
                uri: LegalLinks.websiteUrl,
              ),
              const SizedBox(height: 24),
              AboutSectionTitle(l10n.about_dialog_legend_title),
              const SizedBox(height: 12),
              SpringLegendRow(
                icon: SpringIcon.flowing,
                label: l10n.about_dialog_legend_flowing,
              ),
              SpringLegendRow(
                icon: SpringIcon.notFlowing,
                label: l10n.about_dialog_legend_not_flowing,
              ),
              SpringLegendRow(
                icon: SpringIcon.stale,
                label: l10n.about_dialog_legend_stale,
              ),
              SpringLegendRow(
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
              AboutSectionTitle(l10n.about_legal_privacy_title),
              const SizedBox(height: 10),
              Text(
                l10n.about_legal_privacy_body,
                style: text.body2.copyWith(color: colors.neutral700),
              ),
              const SizedBox(height: 24),
              AboutSectionTitle(l10n.about_legal_documents_title),
              const SizedBox(height: 10),
              Text(
                l10n.about_legal_documents_body,
                style: text.body2.copyWith(color: colors.neutral700),
              ),
              const SizedBox(height: 6),
              LegalLinkButton(
                icon: Icons.gavel_rounded,
                label: l10n.legal_link_terms,
                uri: LegalLinks.termsUrl,
              ),
              LegalLinkButton(
                icon: Icons.privacy_tip_rounded,
                label: l10n.legal_link_privacy,
                uri: LegalLinks.privacyUrl,
              ),
              LegalLinkButton(
                icon: Icons.dataset_linked_rounded,
                label: l10n.legal_link_data_sources,
                uri: LegalLinks.dataSourcesUrl,
              ),
              LegalLinkButton(
                icon: Icons.contact_support_rounded,
                label: l10n.legal_link_contact,
                uri: LegalLinks.contactUrl,
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
              Text(
                l10n.about_legal_version_line(
                  ref
                      .watch(appVersionProvider)
                      .when(
                        data: (version) => version,
                        error: (_, _) => l10n.about_legal_version_loading,
                        loading: () => l10n.about_legal_version_loading,
                      ),
                ),
                style: text.body2.copyWith(
                  fontSize: 12,
                  color: colors.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
