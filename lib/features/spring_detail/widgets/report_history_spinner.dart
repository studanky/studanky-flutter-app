import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

class ReportHistorySpinner extends StatelessWidget {
  const ReportHistorySpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: context.appColors.primaryMain,
      ),
    );
  }
}
