import 'package:flutter/widgets.dart';

/// An advisory map status (offline, or an empty viewport) rendered as a strip
/// *attached under the search field*, inside the search bar's glass card — so
/// the status reads as context belonging to the top chrome instead of a second
/// glass pill twinned with the search bar.
///
/// Presentation-ready: the map page resolves the copy and theme-aware accent and
/// hands the search widget a finished [MapSearchStatus], keeping the search
/// widget unaware of connectivity / marker providers.
@immutable
class MapSearchStatus {
  const MapSearchStatus({
    required this.id,
    required this.icon,
    required this.title,
    required this.message,
    required this.accent,
    this.busy = false,
  });

  /// Stable discriminator (e.g. `offline`, `empty`) so the strip cross-fades
  /// when the reason for the status changes.
  final String id;

  /// Leading glyph; replaced by a spinner while [busy].
  final IconData icon;
  final String title;
  final String message;

  /// Leading-icon accent — communicates the kind of status (a calm brand blue
  /// for an empty map, a warmer amber for offline) and tints the icon chip.
  final Color accent;

  /// Show a spinner in place of [icon] (e.g. re-fetching an empty viewport).
  final bool busy;
}
