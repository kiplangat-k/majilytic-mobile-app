// lib/core/config/auth_config.dart

class AuthConfig {
  // 🔑 Storage key lookup indices for secure persistence matching your Spring Boot filters
  static const String tokenStorageKey = 'MAJILYTICS_AUTH_JWT_TOKEN';
  static const String userSessionStorageKey = 'MAJILYTICS_USER_SESSION';

  static const String authorizationHeaderName = 'Authorization';
  static const String tokenPrefix = 'Bearer ';

  /// Assembles interceptor authorization map templates cleanly
  static Map<String, String> buildAuthenticatedHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      authorizationHeaderName: '$tokenPrefix$token',
    };
  }
}