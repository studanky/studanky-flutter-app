import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/spring_detail/providers/spring_reports_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/report_tile.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Builds the "Historie záznamů" section as a list of slivers so it shares the
/// sheet's single scroll view (and thus its drag-to-expand gesture).
///
/// Renders the right state from [state]: a first-page spinner, an error with
/// retry, an empty message, or the accumulated list with a load-more footer.
List<Widget> buildReportHistorySlivers(
  BuildContext context, {
  required SpringReportsState state,
  required VoidCallback onRetry,
  required VoidCallback onRetryLoadMore,
}) {
  return [
    SliverToBoxAdapter(child: _SectionTitle(total: state.total)),
    _historyContent(context, state, onRetry),
    SliverToBoxAdapter(
      child: _Footer(state: state, onRetryLoadMore: onRetryLoadMore),
    ),
  ];
}

Widget _historyContent(
  BuildContext context,
  SpringReportsState state,
  VoidCallback onRetry,
) {
  if (state.isInitialLoading) {
    return const SliverToBoxAdapter(child: _CenteredPadding(child: _Spinner()));
  }

  if (state.hasInitialError) {
    return SliverToBoxAdapter(
      child: _CenteredPadding(
        child: _InlineError(
          message: context.l10n.spring_detail_history_error,
          onRetry: onRetry,
        ),
      ),
    );
  }

  if (state.isEmpty) {
    return SliverToBoxAdapter(
      child: _CenteredPadding(
        child: Text(
          context.l10n.spring_detail_history_empty,
          style: Styles.textStyles.body2.copyWith(
            color: Styles.appColors.neutral700,
          ),
        ),
      ),
    );
  }

  final reports = state.reports;
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    sliver: SliverList.separated(
      itemCount: reports.length,
      separatorBuilder: (context, _) => Divider(
        height: 1,
        color: Styles.appColors.neutral200,
      ),
      itemBuilder: (context, index) => ReportTile(
        key: ValueKey(reports[index].documentId),
        report: reports[index],
        initiallyExpanded: index == 0,
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Text(
            context.l10n.spring_detail_history_title,
            style: text.title1.copyWith(color: colors.neutral900),
          ),
          if (total > 0) ...[
            const SizedBox(width: 8),
            Text(
              '$total',
              style: text.body2.copyWith(color: colors.neutral500),
            ),
          ],
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state, required this.onRetryLoadMore});

  final SpringReportsState state;
  final VoidCallback onRetryLoadMore;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return const _CenteredPadding(child: _Spinner());
    }

    if (state.loadMoreError != null) {
      return _CenteredPadding(
        child: _InlineError(
          message: context.l10n.spring_detail_history_load_more_error,
          onRetry: onRetryLoadMore,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _CenteredPadding extends StatelessWidget {
  const _CenteredPadding({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Center(child: child),
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: Styles.appColors.primaryMain,
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: text.body2.copyWith(color: colors.neutral700),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onRetry,
          child: Text(context.l10n.error_widget_default_try_again),
        ),
      ],
    );
  }
}
