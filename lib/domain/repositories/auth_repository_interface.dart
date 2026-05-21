import '../entities/user.dart';

abstract class AuthRepositoryInterface {
  Future<User> register(Map<String, dynamic> registrationData);
  Future<Map<String, dynamic>> login(String phoneNumber, String password);
  Future<void> verifyOtp(String phoneNumber, String otpCode);
}