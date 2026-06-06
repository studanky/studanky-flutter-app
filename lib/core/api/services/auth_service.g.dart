// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthService)
final authServiceProvider = AuthServiceProvider._();

final class AuthServiceProvider
    extends $NotifierProvider<AuthService, AuthenticationState> {
  AuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authServiceHash();

  @$internal
  @override
  AuthService create() => AuthService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthenticationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthenticationState>(value),
    );
  }
}

String _$authServiceHash() => r'b9af4be8b18c8c15fdaa06e7d7bc65d20268b3ba';

abstract class _$AuthService extends $Notifier<AuthenticationState> {
  AuthenticationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthenticationState, AuthenticationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthenticationState, AuthenticationState>,
              AuthenticationState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Retrofit-backed authentication API bound to the shared [Dio] client.

@ProviderFor(authApi)
final authApiProvider = AuthApiProvider._();

/// Retrofit-backed authentication API bound to the shared [Dio] client.

final class AuthApiProvider
    extends $FunctionalProvider<AuthApi, AuthApi, AuthApi>
    with $Provider<AuthApi> {
  /// Retrofit-backed authentication API bound to the shared [Dio] client.
  AuthApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authApiHash();

  @$internal
  @override
  $ProviderElement<AuthApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthApi create(Ref ref) {
    return authApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthApi>(value),
    );
  }
}

String _$authApiHash() => r'7f8f3295d155d64a23d89a39198a1a3354c334e6';

@ProviderFor(secureStorage)
final secureStorageProvider = SecureStorageProvider._();

final class SecureStorageProvider
    extends
        $FunctionalProvider<
          FlutterSecureStorage,
          FlutterSecureStorage,
          FlutterSecureStorage
        >
    with $Provider<FlutterSecureStorage> {
  SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<FlutterSecureStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FlutterSecureStorage create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterSecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlutterSecureStorage>(value),
    );
  }
}

String _$secureStorageHash() => r'218285b54a8f75fe2f90555dc062d6cdc992586c';
