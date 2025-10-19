/// Shared configuration for Mapy.cz integrations.
class MapyConfig {
  /// Mapy.cz API key used for tiles and suggest endpoints.
  ///
  /// Replace with your own key or inject it through a different mechanism
  /// (e.g. secrets manager) before shipping to production.
  static const String apiKey = String.fromEnvironment(
    'MAPY_API_KEY',
    defaultValue: 'U4_1WylUX52au77JaAJbXlLAGOCvrfCC1L1bVMwGIqQ',
  );

  static const String suggestHost = 'api.mapy.cz';
  static const String suggestBaseUrl = 'https://$suggestHost';
  static const String suggestPath = '/v1/suggest';
}
