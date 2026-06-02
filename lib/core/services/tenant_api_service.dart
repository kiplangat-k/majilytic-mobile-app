// lib/features/services/tenant_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

// 🟢 FIXED: Using one uniform, absolute package path definition to clear the namespace clash
import 'package:majilytic/features/services/token_storage_service.dart';

class TenantApiService {
  final TokenStorageService _tokenStorage;
  // Change this to match your Spring Boot server port/address (e.g., your local machine IP or localhost)
  final String baseUrl = "http://localhost:8080/api/v1/tenant";

  TenantApiService(this._tokenStorage);

  /// Fetches real-time meter readings, billing balances, and wallet information
  Future<Map<String, dynamic>> getTenantMetrics() async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse('$baseUrl/metrics'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 🔑 Attaching the JWT token resolves your 401 Security Fault
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to synchronize tenant data: Server Fault [${response.statusCode}]');
    }
  }
}