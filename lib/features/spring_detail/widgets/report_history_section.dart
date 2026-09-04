import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/shapes.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/spring_detail/providers/spring_reports_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/centered_content.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/inline_retry_message.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/report_history_card.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/report_history_footer.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/report_history_section_title.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/report_history_spinner.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/report_tile.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

List<Widget> buildReportHistorySlivers(
  BuildContext context, {
  required SpringReportsState state,
  required int maxFlowScale,
  required VoidCallback onRetry,
  required VoidCallback onRetryLoadMore,
}) {
  return [
    SliverToBoxAdapter(child: ReportHistorySectionTitle(total: state.total)),
    _historyContent(context, state, maxFlowScale, onRetry),
    SliverToBoxAdapter(
      child: ReportHistoryFooter(
        state: state,
        onRetryLoadMore: onRetryLoadMore,
      ),
    ),
  ];
}

Widget _historyContent(
  BuildContext context,
  SpringReportsState state,
  int maxFlowScale,
  VoidCallback onRetry,
) {
  if (state.isInitialLoading) {
    return const SliverToBoxAdapter(
      child: ReportHistoryCard(
        child: CenteredContent(child: ReportHistorySpinner()),
      ),
    );
  }

  if (state.hasInitialError) {
    return SliverToBoxAdapter(
      child: ReportHistoryCard(
        child: CenteredContent(
          child: InlineRetryMessage(
            message: context.l10n.spring_detail_history_error,
            onRetry: onRetry,
          ),
        ),
      ),
    );
  }

  if (state.isEmpty) {
    return SliverToBoxAdapter(
      child: ReportHistoryCard(
        child: CenteredContent(
          child: Text(
            context.l10n.spring_detail_history_empty,
            style: context.appTextStyles.body2.copyWith(
              color: context.appColors.neutral700,
            ),
          ),
        ),
      ),
    );
  }

  final reports = state.reports;
  final colors = context.appColors;
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    sliver: DecoratedSliver(
      decoration: ShapeDecoration(
        color: colors.onNeutral,
        shape: squircleBorder(
          kRadiusControl,
          side: BorderSide(color: colors.neutral200),
        ),
      ),
      sliver: SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        sliver: SliverList.separated(
          itemCount: reports.length,
          separatorBuilder: (context, _) =>
              const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (context, index) => ReportTile(
            key: ValueKey(reports[index].documentId),
            report: reports[index],
            maxFlowScale: maxFlowScale,
            initiallyExpanded: index == 0,
          ),
        ),
      ),
    ),
  );
}
