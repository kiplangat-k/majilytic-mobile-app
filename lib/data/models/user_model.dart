class UserModel {
  final int? id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String accountNumber;
  final double walletBalance;
  final String role;
  final bool otpVerified;
  final bool isActive;

  UserModel({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    required this.accountNumber,
    required this.walletBalance,
    required this.role,
    required this.otpVerified,
    required this.isActive,
  });

  // Parses incoming Spring Boot User Entity JSON map seamlessly
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      fullName: json['full_name'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      email: json['email'] as String?,
      accountNumber: json['account_number'] as String? ?? '',
      walletBalance: double.parse((json['wallet_balance'] ?? 0.0).toString()),
      role: json['role'] as String? ?? 'CUSTOMER',
      otpVerified: json['otp_verified'] == true || json['otp_verified'] == 1,
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }

  // Converts parameters into an outbound request payload map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'email': email,
      'account_number': accountNumber,
      'wallet_balance': walletBalance,
      'role': role,
      'otp_verified': otpVerified ? 1 : 0,
      'is_active': isActive ? 1 : 0,
    };
  }
}