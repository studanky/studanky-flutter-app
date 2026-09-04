import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/platform/url_launcher_external_url_launcher.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

class LegalLinkButton extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () =>
            unawaited(ref.read(externalUrlLauncherProvider).open(uri)),
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: TextButton.styleFrom(
          foregroundColor: colors.primaryInteractive,
          textStyle: context.appTextStyles.button,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
