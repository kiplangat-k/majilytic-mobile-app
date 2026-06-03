// lib/core/services/tenant_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class TenantApiService {
  final String baseUrl;
  final String? token;

  TenantApiService({required this.baseUrl, this.token});

  // Common authorization and content-type headers wrapper
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  /// 1. Used by DashboardProvider
  Future<Map<String, dynamic>> getTenantMetrics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tenant/metrics'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch dashboard metrics. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network stack pipeline failure: $e');
    }
  }

  /// 2. Used by TenantProvider (FIXES THE FIRST ERROR)
  Future<List<dynamic>> fetchAvailableProperties() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tenant/properties'), // Adjust path to your Spring Boot controller
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load available properties. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Property fetch connection failed: $e');
    }
  }

  /// 3. Used by TenantProvider (FIXES THE SECOND ERROR)
  Future<Map<String, dynamic>> submitMaintenanceRequest(String title, String description) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tenant/maintenance'), // Adjust path to your Spring Boot controller
        headers: _headers,
        body: jsonEncode({
          'title': title,
          'description': description,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to submit maintenance ticket. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Maintenance ticket delivery pipeline dropped: $e');
    }
  }
}