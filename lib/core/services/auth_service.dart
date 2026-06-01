// lib/core/services/auth_service.dart

import 'api_service.dart';
import '../constants/api_constants.dart';
import '../config/auth_config.dart';
import 'storage_service.dart';
import '../network/auth_interceptor.dart';

class AuthService extends ApiService {
  final StorageService _storageService;

  AuthService(super.apiClient, this._storageService);

  /// Authenticates credentials with your Spring Boot back-end
  Future<String?> executeLoginHandshake(String email, String password) async {
    try {
      final response = await client.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final verifiedMap = verifyResponseJson(response);
      final String? token = verifiedMap['token'] ?? verifiedMap['data']?['token'];

      if (token != null && token.isNotEmpty) {
        // 🔒 Synchronize secure hardware token across persistent layers
        await _storageService.writeString(AuthConfig.tokenStorageKey, token);
        AuthInterceptor.setToken(token);
        return token;
      }
      return null;
    } catch (e) {
      rethrow; // Re-throw to let Clean Architecture handlers catch and wrap it
    }
  }

  /// Dispatches One-Time Password tokens to verified mobile communication layers
  Future<bool> verifyOneTimePassword(String email, String otpCode) async {
    try {
      final response = await client.post(
        ApiConstants.verifyOtp,
        data: {
          'email': email,
          'otpCode': otpCode,
        },
      );
      final verifiedMap = verifyResponseJson(response);
      return verifiedMap['success'] == true || verifiedMap['status'] == 'VERIFIED';
    } catch (e) {
      return false;
    }
  }

  /// Terminate active user sessions securely
  Future<void> executeLogoutSequence() async {
    await _storageService.removeKey(AuthConfig.tokenStorageKey);
    AuthInterceptor.clearToken();
  }
}