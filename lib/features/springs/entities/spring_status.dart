/// Latest known flow status of a spring, as served on the map marker payload
/// (`current_status`, not localized — api-reference.md §3.1).
///
/// This is the *raw* status; the three-state map icon (which adds "stale") is
/// derived from this plus the freshness threshold in `platform_config`.
enum SpringStatus {
  isFlowing('is_flowing'),
  isNotFlowing('is_not_flowing'),
  unknown('unknown');

  const SpringStatus(this.wireValue);

  /// The exact string used by the API.
  final String wireValue;

  /// Parses the API value, falling back to [unknown] for null or any
  /// unrecognised value (forward-compatible with new server enum members).
  static SpringStatus fromWire(String? value) {
    for (final status in values) {
      if (status.wireValue == value) return status;
    }
    return unknown;
  }
}
