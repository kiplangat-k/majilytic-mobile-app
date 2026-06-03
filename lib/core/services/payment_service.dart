// lib/services/payment_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  final String baseUrl = "http://10.0.2.2:8080/api/v1";

  // 1. Trigger M-Pesa STK Push via MpesaController (Inserts into payments table)
  Future<Map<String, dynamic>> initiateStkPush({
    required String phoneNumber,
    required double amount,
    required int userId,
    int? billId,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mpesa/stkpush'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'phone_number': phoneNumber, // maps to phone_number column
          'amount': amount,             // maps to amount column
          'user_id': userId,           // maps to user_id reference
          'bill_id': billId,           // optional nullable link to targeted bill
        }),
      );

      if (response.statusCode == 200) {
        // Returns backend response containing corporate MerchantRequestID & CheckoutRequestID
        return jsonDecode(response.body);
      } else {
        throw Exception('STK Push Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Payment API execution error: $e');
    }
  }

  // 2. Query actual payment processing status (Checks if PENDING changed to SUCCESS)
  Future<String> checkPaymentStatus(String checkoutRequestId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mpesa/status/$checkoutRequestId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status']; // Returns 'PENDING', 'SUCCESS', or 'FAILED'
      }
      return 'PENDING';
    } catch (e) {
      return 'PENDING';
    }
  }

  // 3. Fetch real-time User Account Balance via WalletController
  Future<double> getWalletBalance(int userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wallet/balance/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extracts the decimal wallet_balance value from your users table structure
        return double.parse(data['wallet_balance'].toString());
      } else {
        throw Exception('Failed to get balance');
      }
    } catch (e) {
      throw Exception('Wallet balance check error: $e');
    }
  }

  // 4. Fetch internal transaction ledger logs via TransactionController
  Future<List<Map<String, dynamic>>> getWalletTransactions(int userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transactions/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to retrieve statement logs');
      }
    } catch (e) {
      throw Exception('Ledger connection error: $e');
    }
  }
}