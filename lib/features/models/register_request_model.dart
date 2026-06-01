// lib/features/models/register_request_model.dart

class RegisterRequestModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String accountNumber;
  final String role;
  final String password;

  const RegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.accountNumber,
    required this.role,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName.trim(),
      'email': email.trim().toLowerCase(),
      'phoneNumber': phoneNumber.trim(),
      'accountNumber': accountNumber.trim(),
      'role': role.trim(),
      'password': password,
    };
  }
}