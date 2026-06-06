// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// In-memory holder for the current bearer token.
///
/// Deliberately depends on **nothing** so both the auth-stack Dio and the main
/// Dio can read the token without creating a provider cycle. [AuthService] is
/// the sole writer; the Dio interceptors are readers. This is what breaks the
/// former `dioProvider → authServiceProvider → authApiProvider → dioProvider`
/// circular dependency.

@ProviderFor(AuthToken)
final authTokenProvider = AuthTokenProvider._();

/// In-memory holder for the current bearer token.
///
/// Deliberately depends on **nothing** so both the auth-stack Dio and the main
/// Dio can read the token without creating a provider cycle. [AuthService] is
/// the sole writer; the Dio interceptors are readers. This is what breaks the
/// former `dioProvider → authServiceProvider → authApiProvider → dioProvider`
/// circular dependency.
final class AuthTokenProvider extends $NotifierProvider<AuthToken, String?> {
  /// In-memory holder for the current bearer token.
  ///
  /// Deliberately depends on **nothing** so both the auth-stack Dio and the main
  /// Dio can read the token without creating a provider cycle. [AuthService] is
  /// the sole writer; the Dio interceptors are readers. This is what breaks the
  /// former `dioProvider → authServiceProvider → authApiProvider → dioProvider`
  /// circular dependency.
  AuthTokenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authTokenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authTokenHash();

  @$internal
  @override
  AuthToken create() => AuthToken();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$authTokenHash() => r'4e5d627361b728be8a0849a496c00faadf18be71';

/// In-memory holder for the current bearer token.
///
/// Deliberately depends on **nothing** so both the auth-stack Dio and the main
/// Dio can read the token without creating a provider cycle. [AuthService] is
/// the sole writer; the Dio interceptors are readers. This is what breaks the
/// former `dioProvider → authServiceProvider → authApiProvider → dioProvider`
/// circular dependency.

abstract class _$AuthToken extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
