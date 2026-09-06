import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_token_provider.g.dart';

/// In-memory holder for the current bearer token.
///
/// Deliberately depends on **nothing** so both the auth-stack Dio and the main
/// Dio can read the token without creating a provider cycle. The auth
/// repository is the sole writer; the Dio interceptors are readers. This
/// breaks the former `dioProvider → auth controller → auth API → dioProvider`
/// circular dependency.
@Riverpod(keepAlive: true)
class AuthToken extends _$AuthToken {
  @override
  String? build() => null;

  void setToken(String? token) => state = token;

  void clear() => state = null;
}
