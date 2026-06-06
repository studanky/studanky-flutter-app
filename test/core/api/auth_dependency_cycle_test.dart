import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/core/api/dio/dio_provider.dart';
import 'package:studanky_flutter_app/core/api/services/auth_service.dart';
import 'package:studanky_flutter_app/core/api/services/auth_token_provider.dart';

/// Regression test for the `CircularDependencyError` that occurred when the
/// first authenticated request went through the main Dio at startup:
/// `dioProvider → authServiceProvider → authApiProvider → dioProvider`.
///
/// The fix moves the auth stack onto a separate `authDio` and reads the token
/// from the dependency-free [authTokenProvider]. These reads exercise the same
/// graph edges the interceptors take, so a regression would resurface here.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // AuthService.build() kicks off _initialize(), which reads secure storage.
    // Stub the platform channel so it returns "no stored credentials".
    const channel = MethodChannel(
      'plugins.it_nomads.com/flutter_secure_storage',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'readAll') return <String, String>{};
          return null;
        });
  });

  test('main Dio and auth stack resolve without a circular dependency', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Building the main Dio constructs AuthInterceptor(ref: dioProvider.ref).
    expect(() => container.read(dioProvider), returnsNormally);

    // The edge that used to close the cycle: reading the auth service from the
    // main Dio's perspective. Safe now that authApi runs on authDio.
    expect(() => container.read(authServiceProvider.notifier), returnsNormally);

    // The token read both interceptors perform on every request.
    expect(() => container.read(authTokenProvider), returnsNormally);

    // The dedicated auth Dio resolves independently of the main Dio.
    expect(() => container.read(authDioProvider), returnsNormally);

    // Let AuthService's async _initialize() settle before the container is
    // disposed at teardown, so it doesn't touch its Ref post-dispose.
    await Future<void>.delayed(const Duration(milliseconds: 50));
  });

  test('AuthToken holder defaults to null and updates', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(authTokenProvider), isNull);

    container.read(authTokenProvider.notifier).setToken('jwt-123');
    expect(container.read(authTokenProvider), 'jwt-123');

    container.read(authTokenProvider.notifier).clear();
    expect(container.read(authTokenProvider), isNull);
  });
}
