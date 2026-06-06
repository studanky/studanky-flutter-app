import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_provider.g.dart';

/// App-wide [SharedPreferences] handle for non-sensitive local persistence.
///
/// [SharedPreferences.getInstance] is async, so this provider is **overridden
/// with the resolved instance in `main()`** before `runApp` (see main.dart).
/// Reading it without that override is a programming error and throws.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError(
  'sharedPreferencesProvider must be overridden with a resolved instance in '
  'main() via ProviderScope(overrides: ...).',
);
