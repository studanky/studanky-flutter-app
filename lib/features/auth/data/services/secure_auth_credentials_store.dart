import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/dtos/user_dto.dart';
import 'package:studanky_flutter_app/features/auth/data/services/auth_credentials_store.dart';

part 'secure_auth_credentials_store.g.dart';

/// Keychain/Keystore implementation of [AuthCredentialsStore].
class SecureAuthCredentialsStore implements AuthCredentialsStore {
  const SecureAuthCredentialsStore(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<StoredCredentials?> readCredentials() async {
    final email = await _storage.read(key: ApiConfig.credentialsEmailKey);
    final password = await _storage.read(key: ApiConfig.credentialsPasswordKey);
    if (email == null || password == null) return null;
    return (email: email, password: password);
  }

  @override
  Future<UserDto?> readUser() async {
    final value = await _storage.read(key: ApiConfig.userKey);
    if (value == null) return null;
    return UserDto.fromJson(jsonDecode(value) as Map<String, dynamic>);
  }

  @override
  Future<void> saveAuthenticated({
    required String email,
    required String password,
    required UserDto user,
  }) => _save(email: email, password: password, user: user);

  @override
  Future<void> saveRegistration({
    required String email,
    required String password,
    required UserDto user,
  }) => _save(email: email, password: password, user: user);

  Future<void> _save({
    required String email,
    required String password,
    required UserDto user,
  }) async {
    // SECURITY: Strapi users-permissions has no refresh-token flow out of the
    // box, so the password remains in the platform secure store for silent
    // re-authentication. Replace this with refresh-token rotation when the API
    // supports it; see API_DOCUMENTATION.md.
    await _storage.write(key: ApiConfig.credentialsEmailKey, value: email);
    await _storage.write(
      key: ApiConfig.credentialsPasswordKey,
      value: password,
    );
    await updateUser(user);
  }

  @override
  Future<void> updateUser(UserDto user) =>
      _storage.write(key: ApiConfig.userKey, value: jsonEncode(user.toJson()));

  @override
  Future<void> clear() async {
    await _storage.delete(key: ApiConfig.credentialsEmailKey);
    await _storage.delete(key: ApiConfig.credentialsPasswordKey);
    await _storage.delete(key: ApiConfig.userKey);
  }
}

const _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    storageNamespace: ApiConfig.secureStorageAndroidSharedPreferencesName,
    preferencesKeyPrefix: ApiConfig.secureStorageAndroidPreferencesKeyPrefix,
  ),
  iOptions: IOSOptions(
    accountName: ApiConfig.secureStorageIosAccountName,
    accessibility: ApiConfig.secureStorageIosAccessibility,
    synchronizable: ApiConfig.secureStorageIosSynchronizable,
  ),
);

@Riverpod(keepAlive: true)
AuthCredentialsStore authCredentialsStore(Ref ref) =>
    const SecureAuthCredentialsStore(_secureStorage);
