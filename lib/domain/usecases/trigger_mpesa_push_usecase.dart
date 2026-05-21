import '../repositories/wallet_repository_interface.dart';

class TriggerMpesaPushUseCase {
  final WalletRepositoryInterface repository;

  TriggerMpesaPushUseCase(this.repository);

  Future<Map<String, dynamic>> execute({
    required String phoneNumber,
    required double amount,
    required String token,
  }) async {
    if (amount <= 0) {
      throw Exception('Deposit transaction value must be higher than zero.');
    }

    // Handshake downstream to trigger STK push parameters via MpesaController
    return await repository.triggerMpesaDeposit(
      phoneNumber: phoneNumber,
      amount: amount,
      authToken: token,
    );
  }
}