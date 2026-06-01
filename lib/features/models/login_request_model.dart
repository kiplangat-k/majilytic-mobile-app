// lib/features/models/login_request_model.dart

class LoginRequestModel {
  final String phone_number;
  final String password;

  const LoginRequestModel({
    required this.phone_number,
    required this.password,
  });

  /// Converts inputs to structured JSON map format
  Map<String, dynamic> toJson() {
    return {
      'phone_number': phone_number,
      'password': password,
    };
  }
}