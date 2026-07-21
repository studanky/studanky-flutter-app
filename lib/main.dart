import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studanky_flutter_app/core/navigation/app_router.dart';
import 'package:studanky_flutter_app/core/providers/shared_preferences_provider.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors.dart';
import 'package:studanky_flutter_app/core/styles/theme/app_theme.dart';
import 'package:studanky_flutter_app/core/styles/theme/theme_mode_provider.dart';
import 'package:studanky_flutter_app/features/legal/providers/legal_onboarding_provider.dart';
import 'package:studanky_flutter_app/features/legal/widgets/legal_onboarding_dialog.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/l10n/app_locale_resolution.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

void _setLogging() {
  Logger.root.level = kReleaseMode ? Level.WARNING : Level.ALL;
  if (!kReleaseMode) {
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
  }
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

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> with WidgetsBindingObserver {
  bool _legalOnboardingScheduled = false;
  bool _legalOnboardingVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleLegalOnboardingIfNeeded();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// The OS switched light/dark while the app is running. Rebuild so the
  /// effective brightness (and the synced [AppColors] singleton) update when
  /// the theme mode is [ThemeMode.system].
  @override
  void didChangePlatformBrightness() => setState(() {});

  void _scheduleLegalOnboardingIfNeeded() {
    if (!mounted ||
        _legalOnboardingScheduled ||
        _legalOnboardingVisible ||
        ref.read(legalOnboardingProvider)) {
      return;
    }

    _legalOnboardingScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _legalOnboardingScheduled = false;
      if (!mounted ||
          _legalOnboardingVisible ||
          ref.read(legalOnboardingProvider)) {
        return;
      }

      final navigatorContext = rootNavigatorKey.currentContext;
      if (navigatorContext == null) {
        _scheduleLegalOnboardingIfNeeded();
        return;
      }

      _legalOnboardingVisible = true;
      await showLegalOnboardingDialog(navigatorContext);
      _legalOnboardingVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Warm up the platform config right after startup so its background refresh
    // begins immediately, independent of which screen is shown first. The
    // provider is keepAlive, so it stays initialised for the app's lifetime.
    ref
      ..watch(platformConfigControllerProvider)
      ..listen<bool>(legalOnboardingProvider, (_, acknowledged) {
        if (!acknowledged) _scheduleLegalOnboardingIfNeeded();
      });

    final themeMode = ref.watch(themeModeProvider);

    // Resolve the brightness the theme will actually use and sync the
    // [Styles.appColors] singleton *before* building the page tree, so
    // hand-rolled widgets that read `Styles.appColors.xxx` are correct on the
    // very first frame (no light→dark flash at launch).
    final platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final effectiveBrightness = switch (themeMode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => platformBrightness,
    };
    AppColors().setBrightness(effectiveBrightness);

    return MaterialApp.router(
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: (locales, supportedLocales) =>
          resolveAppLocale(locales),
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
    );
  }
}
