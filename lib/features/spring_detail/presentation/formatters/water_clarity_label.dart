import 'package:studanky_flutter_app/features/spring_detail/entities/water_clarity.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

String waterClarityLabel(WaterClarity clarity, AppLocalizations l10n) =>
    switch (clarity) {
      WaterClarity.crystalClear => l10n.water_clarity_crystal_clear,
      WaterClarity.clear => l10n.water_clarity_clear,
      WaterClarity.slightlyTurbid => l10n.water_clarity_slightly_turbid,
      WaterClarity.turbid => l10n.water_clarity_turbid,
      WaterClarity.heavilyTurbid => l10n.water_clarity_heavily_turbid,
    };
