import '../repositories/auth_repository_interface.dart';

class VerifyOtpUseCase {
  final AuthRepositoryInterface repository;

  VerifyOtpUseCase(this.repository);

  Future<void> execute(String phoneNumber, String otpCode) async {
    if (otpCode.length < 4) {
      throw Exception('Invalid token length constraints.');
    }
    return await repository.verifyOtp(phoneNumber, otpCode);
  }
}
