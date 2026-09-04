// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Presentation controller for authentication flows.

@ProviderFor(AuthenticationController)
final authenticationControllerProvider = AuthenticationControllerProvider._();

/// Presentation controller for authentication flows.
final class AuthenticationControllerProvider
    extends $NotifierProvider<AuthenticationController, AuthenticationState> {
  /// Presentation controller for authentication flows.
  AuthenticationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticationControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticationControllerHash();

  @$internal
  @override
  AuthenticationController create() => AuthenticationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthenticationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthenticationState>(value),
    );
  }
}

String _$authenticationControllerHash() =>
    r'972929480d657c77fe418234db55befeb7e6bb93';

/// Presentation controller for authentication flows.

abstract class _$AuthenticationController
    extends $Notifier<AuthenticationState> {
  AuthenticationState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthenticationState, AuthenticationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthenticationState, AuthenticationState>,
              AuthenticationState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
