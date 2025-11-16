class Env {
  const Env._();

  static String get mapyComApiKey =>
      const String.fromEnvironment('MAPY_COM_API_KEY');
}
