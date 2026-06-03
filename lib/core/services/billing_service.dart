// lib/services/billing_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class BillingService {
  // Use 10.0.2.2 for Android Emulator, or your local machine IP for physical devices
  final String baseUrl = "http://10.0.2.2:8080/api/v1/bills";

  // 1. Fetch all bills for a specific user (Tenant/Landlord)
  Future<List<Map<String, dynamic>>> getUserBills(int userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load bills. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Billing network error: $e');
    }
  }

  // 2. Fetch only PENDING bills to show on the payment dashboard
  Future<List<Map<String, dynamic>>> getPendingBills(int userId, String token) async {
    try {
      final allBills = await getUserBills(userId, token);
      // Filters rows where status column equals 'PENDING' matching your ENUM
      return allBills.where((bill) => bill['status'] == 'PENDING').toList();
    } catch (e) {
      throw Exception('Failed to filter pending bills: $e');
    }
  }

  // 3. Fetch a single bill details by its ID
  Future<Map<String, dynamic>> getBillById(int billId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$billId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch bill data');
      }
    } catch (e) {
      throw Exception('Error loading specific invoice: $e');
    }
  }
}