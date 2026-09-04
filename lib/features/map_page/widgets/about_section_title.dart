import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

class AboutSectionTitle extends StatelessWidget {
  const AboutSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.appTextStyles.title1.copyWith(
        color: context.appColors.neutral900,
      ),
    );
  }
}
