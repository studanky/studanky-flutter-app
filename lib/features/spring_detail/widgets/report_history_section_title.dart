import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

class ReportHistorySectionTitle extends StatelessWidget {
  const ReportHistorySectionTitle({super.key, required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = context.appTextStyles;
    final title = context.l10n.spring_detail_history_title.toUpperCase();

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 16, 8),
      child: Text(
        total > 0 ? '$title ($total)' : title,
        style: text.body2.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: colors.textHint,
        ),
      ),
    );
  }
}
