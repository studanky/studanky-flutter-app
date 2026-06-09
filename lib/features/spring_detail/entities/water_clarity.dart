/// Subjective water clarity of a report (api-reference.md §2.2). Not localized
/// on the wire; the UI maps each value to a localized label.
enum WaterClarity {
  crystalClear('crystal_clear'),
  clear('clear'),
  slightlyTurbid('slightly_turbid'),
  turbid('turbid'),
  heavilyTurbid('heavily_turbid');

  const WaterClarity(this.wireValue);

  final String wireValue;

  /// Parses the API value; returns null for null or any unrecognised value
  /// (forward-compatible with new server enum members).
  static WaterClarity? fromWire(String? value) {
    if (value == null) return null;
    for (final clarity in values) {
      if (clarity.wireValue == value) return clarity;
    }
    return null;
  }
}
