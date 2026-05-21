abstract class WalletRepositoryInterface {
  Future<Map<String, dynamic>> triggerMpesaDeposit({
    required String phoneNumber,
    required double amount,
    required String authToken,
  });
}