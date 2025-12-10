// lib/storage/flutter_secure_token_storage.dart
// example implementation using flutter_secure_storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'token_storage.dart';

class FlutterSecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage _storage;
  static const _kAccessKey = 'access_token';
  static const _kRefreshKey = 'refresh_token';

  FlutterSecureTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> clear() async {
    await _storage.delete(key: _kAccessKey);
    await _storage.delete(key: _kRefreshKey);
  }

  @override
  Future<String?> getAccessToken() => _storage.read(key: _kAccessKey);

  @override
  Future<String?> getRefreshToken() => _storage.read(key: _kRefreshKey);

  @override
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _kAccessKey, value: token);

  @override
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _kRefreshKey, value: token);
}
