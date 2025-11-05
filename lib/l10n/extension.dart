import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
