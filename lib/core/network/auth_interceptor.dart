// lib/core/network/auth_interceptor.dart

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../config/auth_config.dart';

class AuthInterceptor extends Interceptor {
  // A simple runtime cache for demonstration. For production, inject a secure local storage repository here.
  static String? _cachedToken;

  /// Sets the active session authorization token dynamically upon successful authentication
  static void setToken(String token) {
    _cachedToken = token;
  }

  /// Clears the token string from the runtime reference cache upon system logout
  static void clearToken() {
    _cachedToken = null;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _cachedToken;

    if (token != null && token.isNotEmpty) {
      options.headers[AuthConfig.authorizationHeaderName] = '${AuthConfig.tokenPrefix}$token';
    }

    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 🔐 Automatically catch session validation errors (HTTP 401 Unauthorized)
    if (err.response?.statusCode == 401) {
      debugPrint('Security Interceptor Trace: Session authentication credentials dropped by host.');
      // Optional: Trigger a stream event here to notify your presentation routing stack to force a Logout redirects
    }
    return handler.next(err);
  }
}