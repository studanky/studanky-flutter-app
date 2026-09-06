import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/platform/external_url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

part 'url_launcher_external_url_launcher.g.dart';

class UrlLauncherExternalUrlLauncher implements ExternalUrlLauncher {
  const UrlLauncherExternalUrlLauncher();

  @override
  Future<bool> open(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);
}

@riverpod
ExternalUrlLauncher externalUrlLauncher(Ref ref) =>
    const UrlLauncherExternalUrlLauncher();
