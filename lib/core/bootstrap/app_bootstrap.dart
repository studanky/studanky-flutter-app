import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studanky_flutter_app/app.dart';
import 'package:studanky_flutter_app/core/bootstrap/bootstrap_error_app.dart';
import 'package:studanky_flutter_app/core/providers/shared_preferences_provider.dart';

/// Initializes process-wide dependencies and starts the Flutter widget tree.
Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configureLogging();

  try {
    final preferences = await SharedPreferences.getInstance();
    runApp(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        child: const MainApp(),
      ),
    );
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'app bootstrap',
        context: ErrorDescription('while loading SharedPreferences'),
      ),
    );
    Logger('Bootstrap').severe('Failed to start the app', error, stackTrace);
    runApp(BootstrapErrorApp(error: error, stackTrace: stackTrace));
  }
}

void _configureLogging() {
  Logger.root.level = kDebugMode ? Level.ALL : Level.WARNING;
  if (!kReleaseMode) {
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
  }
}
