// lib/features/prepaid/wallet/wallet_service.dart

import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';
import 'wallet_model.dart';

class WalletService extends ApiService {
  WalletService(super.apiClient);

  /// Pulls down the contemporary wallet balances and operational metrics
  Future<WalletModel> fetchWalletDetails() async {
    try {
      final response = await client.get('${ApiConstants.dashboardMetricsEndpoint}/wallet');
      final verifiedMap = verifyResponseJson(response);
      return WalletModel.fromJson(verifiedMap);
    } catch (e) {
      rethrow;
    }
  }

  /// Initiates an automated M-Pesa Express STK Push utility sequence to top up funds
  Future<bool> initiateStkPush(String phoneNumber, double amount) async {
    try {
      final response = await client.post(
        '/api/v1/payments/mpesa/stk-push',
        data: {
          'phoneNumber': phoneNumber.trim(),
          'amount': amount,
        },
      );
      final verifiedMap = verifyResponseJson(response);
      return verifiedMap['success'] == true || verifiedMap['status'] == 'PENDING';
    } catch (_) {
      return false;
    }
  }
}