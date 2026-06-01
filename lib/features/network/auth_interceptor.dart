// lib/core/network/auth_interceptor.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // 🟢 Cleaned up duplicate imports
import '../../features/services/token_storage_service.dart'; // Adjust path if needed

class AuthInterceptor extends Interceptor {
  final TokenStorageService tokenStorageService;

  AuthInterceptor(this.tokenStorageService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 🟢 NOW RESOLVED: Will pull securely from storage seamlessly
    final token = await tokenStorageService.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      debugPrint('Security Interceptor Trace: Session authentication credentials dropped by host.');
    }
    return handler.next(err);
  }
}