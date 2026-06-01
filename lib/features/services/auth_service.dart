// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Base API endpoint
  // (10.0.2.2 seamlessly redirects to localhost if you are using an Android Emulator)
  // If you are testing on a real Android device, change this to your machine's local IP address.
  final String baseUrl = 'http://127.0.0.1:8080/api/auth';

  /// Registers a new user with the backend
  Future<bool> registerUser({
    required String phoneNumber,
    required String fullName,
    required String email,
    required String accountNumber,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'fullName': fullName,
          'email': email,                  // Passed to Spring Boot
          'accountNumber': accountNumber,  // Passed to Spring Boot
          'password': password,
          'role': role.toUpperCase(),      // Sends "TENANT", "LANDLORD", or "ADMIN"
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Network error during registration: $e");
      return false;
    }
  }
}