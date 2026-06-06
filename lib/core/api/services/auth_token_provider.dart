import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_token_provider.g.dart';

/// In-memory holder for the current bearer token.
///
/// Deliberately depends on **nothing** so both the auth-stack Dio and the main
/// Dio can read the token without creating a provider cycle. `AuthService` is
/// the sole writer; the Dio interceptors are readers. This is what breaks the
/// former `dioProvider → authServiceProvider → authApiProvider → dioProvider`
/// circular dependency.
@Riverpod(keepAlive: true)
class AuthToken extends _$AuthToken {
  @override
  String? build() => null;

  void setToken(String? token) => state = token;

  void clear() => state = null;
}
