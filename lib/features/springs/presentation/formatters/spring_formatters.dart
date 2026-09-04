import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

/// Presentation-only formatting shared by every spring-facing feature.
class SpringFormatters {
  const SpringFormatters._();

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

  static String shortDate(DateTime when) {
    final local = when.toLocal();
    return '${local.day}. ${local.month}. ${local.year}';
  }

  static String coordinates(LatLng position) {
    final latDir = position.latitude >= 0 ? 'N' : 'S';
    final lngDir = position.longitude >= 0 ? 'E' : 'W';
    final lat = position.latitude.abs().toStringAsFixed(7);
    final lng = position.longitude.abs().toStringAsFixed(7);
    return '$lat$latDir, $lng$lngDir';
  }

  static String flowRate(double lps) {
    final fixed = lps.toStringAsFixed(2);
    final trimmed = fixed.replaceFirst(RegExp(r'\.?0+$'), '');
    return trimmed.replaceAll('.', ',');
  }
}
