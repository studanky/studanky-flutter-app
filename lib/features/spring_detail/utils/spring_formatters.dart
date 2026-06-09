import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

/// Presentation helpers for spring detail. Kept dependency-light (no `intl`
/// locale data) — the app ships Czech only for now and the formats are simple.
class SpringFormatters {
  const SpringFormatters._();

  /// Concrete, human age of a timestamp ("před 3 dny"). Freshness is the
  /// product's core value, so the detail always leads with this (spec §4.2).
  ///
  /// [when] may be UTC; `Duration` is computed on absolute instants so the time
  /// zone of either side does not matter.
  static String relativeAge(
    AppLocalizations l10n,
    DateTime when, {
    DateTime? now,
  }) {
    final diff = (now ?? DateTime.now()).difference(when);

    if (diff.inMinutes < 1) return l10n.age_just_now;
    if (diff.inMinutes < 60) return l10n.age_minutes(diff.inMinutes);
    if (diff.inHours < 24) return l10n.age_hours(diff.inHours);
    return l10n.age_days(diff.inDays);
  }

  /// Absolute date as shown in the history rows ("11. 6. 2025").
  static String shortDate(DateTime when) {
    final local = when.toLocal();
    return '${local.day}. ${local.month}. ${local.year}';
  }

  /// Directional coordinates ("49.2107581N, 16.6188150E").
  static String coordinates(LatLng position) {
    final latDir = position.latitude >= 0 ? 'N' : 'S';
    final lngDir = position.longitude >= 0 ? 'E' : 'W';
    final lat = position.latitude.abs().toStringAsFixed(7);
    final lng = position.longitude.abs().toStringAsFixed(7);
    return '$lat$latDir, $lng$lngDir';
  }

  /// Measured discharge formatted for display ("0.42").
  static String flowRate(double lps) {
    final fixed = lps.toStringAsFixed(2);
    // Trim trailing zeros for a cleaner read (0.40 → 0.4, 1.00 → 1).
    return fixed.contains('.')
        ? fixed.replaceFirst(RegExp(r'\.?0+$'), '')
        : fixed;
  }
}
