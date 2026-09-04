import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/navigation/app_router.dart';
import 'package:studanky_flutter_app/core/styles/theme/app_theme.dart';
import 'package:studanky_flutter_app/core/styles/theme/theme_mode_provider.dart';
import 'package:studanky_flutter_app/features/legal/providers/legal_onboarding_provider.dart';
import 'package:studanky_flutter_app/features/legal/widgets/legal_onboarding_dialog.dart';
import 'package:studanky_flutter_app/features/map_page/providers/user_location_provider.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/l10n/app_locale_resolution.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  bool _legalOnboardingScheduled = false;
  bool _legalOnboardingVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleLegalOnboardingIfNeeded();
    });
  }

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
      if (!mounted || !ref.read(legalOnboardingProvider)) return;

      // Wait until the onboarding route closes before requesting location, so
      // the system sheet never covers a closing application dialog.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(userLocationProvider.notifier).activate();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..watch(platformConfigControllerProvider)
      ..listen<bool>(legalOnboardingProvider, (_, acknowledged) {
        if (!acknowledged) _scheduleLegalOnboardingIfNeeded();
      });

    return MaterialApp.router(
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: (locales, supportedLocales) =>
          resolveAppLocale(locales),
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
    );
  }
}
