/// Widget-free source of truth for the app's public deep links.
///
/// Deliberately free of any `go_router` / widget imports so it sits at the
/// bottom of the dependency graph: both the router (`app_router.dart`, whose
/// `ShareRoute` `@TypedGoRoute` references [springSharePattern]) and feature
/// code (`SpringActions`, which builds share URLs) depend on it — never the
/// other way round. This breaks the import cycle that would otherwise form when
/// a feature reaches back into the widget-heavy router just to reuse a path.
class DeepLinks {
  const DeepLinks._();

  /// Host for public share links, path-scoped to `/s/`. Keep in sync with
  /// `applinks:` / `android:host` in the native config and the AASA /
  /// assetlinks.json `pathPrefix`.
  static const String host = 'studankyapp.cz';

  /// Route pattern for the share entry point. Referenced by `ShareRoute`'s
  /// `@TypedGoRoute` annotation so this pattern is defined exactly once; the
  /// generated `ShareRoute.location` and [springSharePath] therefore agree by
  /// construction.
  static const String springSharePattern = '/s/:documentId';

  /// In-app path for a concrete spring's share link, e.g. `/s/abc123`. Pairs
  /// with [springSharePattern] — the concrete counterpart of that route matcher.
  static String springSharePath(String documentId) =>
      '/s/${Uri.encodeComponent(documentId)}';

  /// The full public https share URL for a spring. Opens the app on the detail
  /// when installed (Universal Links / App Links); otherwise the host's fallback
  /// page redirects to the App Store / Google Play.
  static String springShareUrl(String documentId) =>
      'https://$host${springSharePath(documentId)}';
}
