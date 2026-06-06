import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studanky_flutter_app/core/navigation/app_router.dart';
import 'package:studanky_flutter_app/core/providers/shared_preferences_provider.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

void _setLogging() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setLogging();

  // SharedPreferences resolves asynchronously; load it once here and inject the
  // instance so the synchronous [sharedPreferencesProvider] can be read from
  // anywhere (e.g. the platform config cache) without awaiting.
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Warm up the platform config right after startup so its background refresh
    // begins immediately, independent of which screen is shown first. The
    // provider is keepAlive, so it stays initialised for the app's lifetime.
    ref.watch(platformConfigControllerProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
