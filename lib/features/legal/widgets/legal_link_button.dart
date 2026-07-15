import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/legal/legal_config.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

class LegalLinkButton extends StatelessWidget {
  const LegalLinkButton({
    super.key,
    required this.icon,
    required this.label,
    required this.uri,
  });

  final IconData icon;
  final String label;
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () => unawaited(LegalConfig.open(uri)),
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: TextButton.styleFrom(
          foregroundColor: colors.primaryInteractive,
          textStyle: Styles.textStyles.button,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
