import 'dart:convert';

import 'package:http/http.dart' as http;

class AdminApiService {
  final String baseUrl;
  final String? token;

  AdminApiService({required this.baseUrl, this.token});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  // Get system metrics dashboard
  Future<Map<String, dynamic>> fetchSystemOverview() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/dashboard'), headers: _headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch system dashboard metrics');
    }
  }

  // Suspend/Approve a platform user account
  Future<void> updateUserStatus(String userId, bool isApproved) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/admin/users/$userId'),
      headers: _headers,
      body: jsonEncode({'isApproved': isApproved}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to alter user status');
    }
  }
}