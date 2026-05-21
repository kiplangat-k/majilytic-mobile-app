// Mock implementation wrapper using a baseline logic template.
// To use persistent device storage, add 'shared_preferences' or 'flutter_secure_storage' to your pubspec.yaml.
class StorageService {
  final Map<String, String> _inMemoryStorage = {};

  Future<void> writeToken(String token) async {
    _inMemoryStorage['jwt_auth_token'] = token;
  }

  Future<String?> readToken() async {
    return _inMemoryStorage['jwt_auth_token'];
  }

  Future<void> deleteToken() async {
    _inMemoryStorage.remove('jwt_auth_token');
  }

  Future<void> clearAll() async {
    _inMemoryStorage.clear();
  }
}