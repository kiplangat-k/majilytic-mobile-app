// lib/core/services/tenant_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class TenantApiService {
  final String baseUrl;

  // FIXED: Remove 'final String? token' from constructor parameters
  // Instead, allow a callback or dynamic assignment so GetIt can register it as a permanent singleton.
  String? Function()? _tokenProvider;

  TenantApiService({
    required this.baseUrl,
    String? Function()? tokenProvider,
  }) : _tokenProvider = tokenProvider;

  // A helper method to update the token provider after authentication if needed
  void updateTokenProvider(String? Function() provider) {
    _tokenProvider = provider;
  }

  // FIXED: Evaluates the token from the provider function every single time an API call runs
  Map<String, String> get _headers {
    final activeToken = _tokenProvider?.call();
    return {
      'Content-Type': 'application/json',
      if (activeToken != null) 'Authorization': 'Bearer $activeToken',
    };
  }

  /// Fetches raw metric configurations mapping directly to your Spring Boot DTO
  Future<Map<String, dynamic>> getTenantMetrics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tenant/metrics'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network stack pipeline failure: $e');
    }
  }
}