import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors.dart';

class BootstrapErrorApp extends StatelessWidget {
  const BootstrapErrorApp({
    super.key,
    required this.error,
    required this.stackTrace,
  });

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final colors = AppColors()..setBrightness(brightness);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: brightness,
        scaffoldBackgroundColor: colors.background,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: colors.errorText,
                      size: 44,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Aplikaci se nepodařilo spustit.',
                      style: TextStyle(
                        color: colors.neutral900,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Zkuste ji zavřít a znovu otevřít. Pokud problém '
                      'přetrvá, kontaktujte podporu.',
                      style: TextStyle(
                        color: colors.textHint,
                        fontSize: 16,
                        height: 1.45,
                      ),
                    ),
                    if (!kReleaseMode) ...[
                      const SizedBox(height: 24),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.neutral900.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SelectableText(
                            '$error\n\n$stackTrace',
                            style: TextStyle(
                              color: colors.textHint,
                              fontFamily: 'monospace',
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
