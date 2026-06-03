import 'dart:convert';

import 'package:http/http.dart' as http;

class LandlordApiService {
  final String baseUrl;
  final String? token;

  LandlordApiService({required this.baseUrl, this.token});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  // Fetch landlord's owned properties
  Future<List<dynamic>> fetchMyProperties() async {
    final response = await http.get(Uri.parse('$baseUrl/landlord/properties'), headers: _headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch landlord properties');
    }
  }

  // Create a new property listing
  Future<Map<String, dynamic>> addProperty(Map<String, dynamic> propertyData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/landlord/properties'),
      headers: _headers,
      body: jsonEncode(propertyData),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add property');
    }
  }
}