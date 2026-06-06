// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App-wide [SharedPreferences] handle for non-sensitive local persistence.
///
/// [SharedPreferences.getInstance] is async, so this provider is **overridden
/// with the resolved instance in `main()`** before `runApp` (see main.dart).
/// Reading it without that override is a programming error and throws.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// App-wide [SharedPreferences] handle for non-sensitive local persistence.
///
/// [SharedPreferences.getInstance] is async, so this provider is **overridden
/// with the resolved instance in `main()`** before `runApp` (see main.dart).
/// Reading it without that override is a programming error and throws.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// App-wide [SharedPreferences] handle for non-sensitive local persistence.
  ///
  /// [SharedPreferences.getInstance] is async, so this provider is **overridden
  /// with the resolved instance in `main()`** before `runApp` (see main.dart).
  /// Reading it without that override is a programming error and throws.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'f39308b1e0a9dcf733a88638883987109384abaf';
