// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_auth_credentials_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authCredentialsStore)
final authCredentialsStoreProvider = AuthCredentialsStoreProvider._();

final class AuthCredentialsStoreProvider
    extends
        $FunctionalProvider<
          AuthCredentialsStore,
          AuthCredentialsStore,
          AuthCredentialsStore
        >
    with $Provider<AuthCredentialsStore> {
  AuthCredentialsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authCredentialsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authCredentialsStoreHash();

  @$internal
  @override
  $ProviderElement<AuthCredentialsStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthCredentialsStore create(Ref ref) {
    return authCredentialsStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthCredentialsStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthCredentialsStore>(value),
    );
  }
}

String _$authCredentialsStoreHash() =>
    r'faf94896d543ca225405f7ce13cf3ad12bcbf83e';
