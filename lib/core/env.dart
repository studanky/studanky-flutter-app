/// Compile-time environment configuration.
///
/// Values are injected at build time via `--dart-define` (see
/// `env_vars.json` and the `--dart-define-from-file` launch argument).
/// Secrets therefore never live in source control or in the generated code.
class Env {
  const Env._();

  /// Base URL of the Strapi backend, including the `/api` suffix.
  ///
  /// Defaults to the local development server. Production / staging builds must
  /// override this with an HTTPS endpoint via `--dart-define=BASE_URL=...`.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:1337/api',
  );

  /// API key for the Mapy.com tiles and suggest endpoints.
  static const String mapyComApiKey = String.fromEnvironment(
    'MAPY_COM_API_KEY',
  );

  /// Whether the configured backend is reached over a secure transport.
  static bool get isBaseUrlSecure => baseUrl.startsWith('https://');
}
