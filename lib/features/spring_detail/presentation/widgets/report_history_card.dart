import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/detail_section.dart';

class ReportHistoryCard extends StatelessWidget {
  const ReportHistoryCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DetailCard(padding: EdgeInsets.zero, child: child),
    );
  }
}
