// lib/features/services/admin_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

// 🟢 FIXED: Use a single clean absolute package import to prevent namespace conflicts
import 'package:majilytic/features/services/token_storage_service.dart';

class AdminApiService {
  final TokenStorageService _tokenStorage;
  final String baseUrl = "http://localhost:8080/api/v1/admin";

  AdminApiService(this._tokenStorage);

  Future<Map<String, dynamic>> fetchAdminMetrics() async {
    final token = await _tokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse('$baseUrl/metrics'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to synchronize admin components: Fault [${response.statusCode}]');
    }
  }
}