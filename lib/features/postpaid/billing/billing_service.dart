// lib/features/postpaid/billing/billing_service.dart

import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';
import 'billing_model.dart';

class BillingService extends ApiService {
  BillingService(super.apiClient);

  /// Pulls the complete structural billing history ledger for an account
  Future<List<BillingModel>> fetchAccountStatements() async {
    try {
      final response = await client.get(ApiConstants.billingHistoryEndpoint);

      if (response.data is List) {
        return (response.data as List)
            .map((json) => BillingModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      final verifiedMap = verifyResponseJson(response);
      final rawList = verifiedMap['bills'] ?? verifiedMap['data'] ?? [];
      return (rawList as List)
          .map((json) => BillingModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Triggers a payment request sequence (e.g., STK Push) against an outstanding bill ID
  Future<bool> triggerBillSettlement(String billId, double amount) async {
    try {
      final response = await client.post(
        '${ApiConstants.billingHistoryEndpoint}/settle',
        data: {
          'billId': billId,
          'amount': amount,
        },
      );
      final verifiedMap = verifyResponseJson(response);
      return verifiedMap['success'] == true || verifiedMap['status'] == 'PROCESSING';
    } catch (e) {
      return false;
    }
  }
}