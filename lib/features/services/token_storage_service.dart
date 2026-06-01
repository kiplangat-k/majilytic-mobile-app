// lib/features/services/token_storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  final FlutterSecureStorage _secureStorage;
  static const String _tokenKey = 'jwt_access_token';

  TokenStorageService(this._secureStorage);

  /// 🟢 FIXED: Added the missing method required by your AuthInterceptor
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Saves the authenticated token string securely upon successful logins
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  /// Clears out the saved token instance during user logout sequences
  Future<void> clearSessionData() async {
    await _secureStorage.delete(key: _tokenKey);
  }
}