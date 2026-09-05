import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/centered_content.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/inline_retry_message.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/report_history_spinner.dart';
import 'package:studanky_flutter_app/features/spring_detail/providers/spring_reports_provider.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

class ReportHistoryFooter extends StatelessWidget {
  const ReportHistoryFooter({
    super.key,
    required this.state,
    required this.onRetryLoadMore,
  });

  final SpringReportsState state;
  final VoidCallback onRetryLoadMore;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return const CenteredContent(child: ReportHistorySpinner());
    }

    if (state.loadMoreError != null) {
      return CenteredContent(
        child: InlineRetryMessage(
          message: context.l10n.spring_detail_history_load_more_error,
          onRetry: onRetryLoadMore,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
