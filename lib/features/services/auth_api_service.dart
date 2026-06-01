// lib/features/services/auth_api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';
import '../providers/auth_provider.dart'; // Required to access the AuthResponse structure

class AuthApiService {
  // 🟢 FIXED: Changed from 127.0.0.1 to 10.0.2.2 so your Android Emulator can connect to Spring Boot
  final String baseUrl = 'http://127.0.0.1:8080/api/v1/auth';
  //final String baseUrl = 'http://192.168.0.103:8080/api/v1/auth';

  /// Registers a brand new user profile structure onto the server database
  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String accountNumber,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'accountNumber': accountNumber, // Matches your Spring Boot RegisterRequest DTO exactly
          'password': password,
          'role': role.toUpperCase(), // Explicitly maps 'TENANT', 'LANDLORD', or 'ADMIN'
        }),
      );

      // Check if the Spring Boot backend returned an error status code
      if (response.statusCode != 200 && response.statusCode != 201) {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        // Extracts the dynamic exception message field from your ApiResponse wrapper
        throw Exception(errorData['message'] ?? 'Backend registration failed.');
      }
    } catch (e) {
      // Passes the exception back up to the AuthProvider state machine
      rethrow;
    }
  }

  /// Authenticates credentials against the Spring Boot database engine for login
  Future<AuthResponse> authenticate({
    required String phoneNumber,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == true) {
        final data = responseBody['data'];
        final String token = data['token'];

        // Parse the dynamic backend user profile map straight into your UserModel contract
        final UserModel user = UserModel.fromJson(data['user']);

        return AuthResponse(token: token, user: user);
      } else {
        // Drop backend validation exception text straight into your error snackbars
        throw Exception(responseBody['message'] ?? 'Invalid phone number or password.');
      }
    } catch (e) {
      rethrow;
    }
  }
}