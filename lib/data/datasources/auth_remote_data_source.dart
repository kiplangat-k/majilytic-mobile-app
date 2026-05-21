import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<UserModel> register(Map<String, dynamic> registrationData) async {
    final response = await _apiClient.post(ApiConstants.register, registrationData);
    return UserModel.fromJson(response['user'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> login(String phoneNumber, String password) async {
    final response = await _apiClient.post(ApiConstants.login, {
      'phone_number': phoneNumber,
      'password': password,
    });
    return response; // Contains the 'token' string and 'user' snapshot map
  }

  Future<void> verifyOtp(String phoneNumber, String otpCode) async {
    await _apiClient.post(ApiConstants.verifyOtp, {
      'phone_number': phoneNumber,
      'otp_code': otpCode,
    });
  }
}