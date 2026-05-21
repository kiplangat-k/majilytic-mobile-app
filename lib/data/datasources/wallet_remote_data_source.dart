import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class WalletRemoteDataSource {
  final ApiClient _apiClient;

  WalletRemoteDataSource(this._apiClient);

  // Hits MpesaController to push STK Prompt pin dialog parameters down to Safaricom lines
  Future<Map<String, dynamic>> initiateMpesaDeposit(String phoneNumber, double amount, String token) async {
    return await _apiClient.post(
      ApiConstants.walletDeposit,
      {
        'phone_number': phoneNumber,
        'amount': amount,
      },
      token: token,
    );
  }
}