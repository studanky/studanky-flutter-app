// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Application-wide [Dio] instance pointed at the Strapi backend, wired with
/// authentication (token injection + 401 re-auth), transient-error retries and
/// redacted logging.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Application-wide [Dio] instance pointed at the Strapi backend, wired with
/// authentication (token injection + 401 re-auth), transient-error retries and
/// redacted logging.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Application-wide [Dio] instance pointed at the Strapi backend, wired with
  /// authentication (token injection + 401 re-auth), transient-error retries and
  /// redacted logging.
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'8b9ca4060d7f49bb34febe0f792358f776903a81';

/// Dedicated [Dio] for the authentication endpoints (login, register, refresh,
/// `/users/me`).
///
/// Intentionally **separate** from [dio] and wired with the lightweight
/// [BearerTokenInterceptor] instead of [AuthInterceptor]. This breaks the
/// circular dependency that arose when the auth service (reached via the main
/// Dio's interceptor) also depended on the main Dio: the auth stack now only
/// depends on the dependency-free token holder. It also prevents a reauth loop
/// — a failed login must never trigger another re-authentication.

@ProviderFor(authDio)
final authDioProvider = AuthDioProvider._();

/// Dedicated [Dio] for the authentication endpoints (login, register, refresh,
/// `/users/me`).
///
/// Intentionally **separate** from [dio] and wired with the lightweight
/// [BearerTokenInterceptor] instead of [AuthInterceptor]. This breaks the
/// circular dependency that arose when the auth service (reached via the main
/// Dio's interceptor) also depended on the main Dio: the auth stack now only
/// depends on the dependency-free token holder. It also prevents a reauth loop
/// — a failed login must never trigger another re-authentication.

final class AuthDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Dedicated [Dio] for the authentication endpoints (login, register, refresh,
  /// `/users/me`).
  ///
  /// Intentionally **separate** from [dio] and wired with the lightweight
  /// [BearerTokenInterceptor] instead of [AuthInterceptor]. This breaks the
  /// circular dependency that arose when the auth service (reached via the main
  /// Dio's interceptor) also depended on the main Dio: the auth stack now only
  /// depends on the dependency-free token holder. It also prevents a reauth loop
  /// — a failed login must never trigger another re-authentication.
  AuthDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return authDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$authDioHash() => r'984767d222aba16139d19f200c8d1d127e178ca4';
