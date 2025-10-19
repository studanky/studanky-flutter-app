/// Shared configuration for Mapy.cz integrations.
class MapyConfig {
  /// Mapy.cz API key used for tiles and suggest endpoints.
  ///
  /// Replace with your own key or inject it through a different mechanism
  /// (e.g. secrets manager) before shipping to production.
  static const String apiKey = String.fromEnvironment(
    'U4_1WylUX52au77JaAJbXlLAGOCvrfCC1L1bVMwGIqQ',
    defaultValue: 'U4_1WylUX52au77JaAJbXlLAGOCvrfCC1L1bVMwGIqQ',
  );

  static const String suggestBaseUrl = 'api.mapy.cz';
}
