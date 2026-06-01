// lib/core/network/dio_provider.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import 'auth_interceptor.dart';

class DioProvider {
  final AuthInterceptor authInterceptor;

  // 🟢 Fixed constructor mapping
  DioProvider(this.authInterceptor);

  /// 🟢 FIXED: Changed from a static method to an instance method named 'createDioInstance'
  /// This perfectly aligns with what your DependencyInjection framework expects.
  Dio createDioInstance() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: ApiConstants.connectTimeoutSec),
        receiveTimeout: const Duration(seconds: ApiConstants.receiveTimeoutSec),
      ),
    );

    // 🟢 FIXED: Injects the active, dependency-managed interceptor instance
    // instead of creating a broken empty one via AuthInterceptor()
    dio.interceptors.add(authInterceptor);

    // Enable detailed terminal payload prints when debugging on local machines
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          error: true,
        ),
      );
    }

    return dio;
  }
}