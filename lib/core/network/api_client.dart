import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../errors/failures.dart';
import '../constants/api_constants.dart';

class ApiClient {
  final http.Client _client;
  ApiClient(this._client);

  // UPDATED: Automatically filters headers so public authentication routes don't bundle tokens
  Map<String, String> _getHeaders(String endpoint, String? token) {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Only inject the Bearer authorization if a token exists AND we aren't hitting an auth route
    if (token != null && !endpoint.contains('/auth/')) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // FIXED: Removed the triple-slash typo 'http:///' to correctly evaluate path boundaries
  Uri _buildUri(String endpoint) {
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return Uri.parse(endpoint);
    }
    return Uri.parse('${ApiConstants.baseUrl}$endpoint');
  }

  // HTTP POST Request Wrapper
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body, {String? token}) async {
    final url = _buildUri(endpoint);
    try {
      final response = await _client.post(
        url,
        headers: _getHeaders(endpoint, token), // Passed endpoint here to evaluate path safety
        body: jsonEncode(body),
      ).timeout(const Duration(milliseconds: ApiConstants.connectionTimeout));

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  // HTTP GET Request Wrapper
  Future<Map<String, dynamic>> get(String endpoint, {String? token}) async {
    final url = _buildUri(endpoint);
    try {
      final response = await _client.get(
        url,
        headers: _getHeaders(endpoint, token), // Passed endpoint here to evaluate path safety
      ).timeout(const Duration(milliseconds: ApiConstants.connectionTimeout));

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkFailure();
    }
  }

  // Parses Spring Boot HTTP status payloads safely
  Map<String, dynamic> _handleResponse(http.Response response) {
    final int statusCode = response.statusCode;
    final Map<String, dynamic> decodedBody = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : <String, dynamic>{};

    if (statusCode >= 200 && statusCode < 300) {
      return decodedBody;
    } else if (statusCode == 401 || statusCode == 403) {
      throw AuthFailure(decodedBody['message'] ?? 'Session expired. Please try again.');
    } else if (statusCode >= 400 && statusCode < 500) {
      throw ServerFailure(decodedBody['message'] ?? 'Invalid request processing parameters.');
    } else {
      throw const ServerFailure('Internal system server failure. Try again later.');
    }
  }
}