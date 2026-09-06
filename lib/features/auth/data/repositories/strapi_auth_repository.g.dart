// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strapi_auth_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'711cb94cffe2ba91768eaf7f0afc18d6da7b2e1a';

@ProviderFor(sessionRefresher)
final sessionRefresherProvider = SessionRefresherProvider._();

final class SessionRefresherProvider
    extends
        $FunctionalProvider<
          SessionRefresher,
          SessionRefresher,
          SessionRefresher
        >
    with $Provider<SessionRefresher> {
  SessionRefresherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionRefresherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionRefresherHash();

  @$internal
  @override
  $ProviderElement<SessionRefresher> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SessionRefresher create(Ref ref) {
    return sessionRefresher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionRefresher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionRefresher>(value),
    );
  }
}

String _$sessionRefresherHash() => r'9e397a7a21ec1aa709d7d8db797069701635b9df';
