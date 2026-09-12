import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final storage = const FlutterSecureStorage();

  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';

  Future<void> saveAccessToken(String token) async {
    await storage.write(key: _accessTokenKey, value: token);
  }

  Future<void> saveRefreshToken(String token) async {
    await storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getAccessToken() {
    return storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() {
    return storage.read(key: _refreshTokenKey);
  }

  Future<void> deleteAll() {
    return storage.deleteAll();
  }
}