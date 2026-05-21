class User {
  final int? id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String accountNumber;
  final double walletBalance;
  final String role;
  final bool otpVerified;

  const User({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    required this.accountNumber,
    required this.walletBalance,
    required this.role,
    required this.otpVerified,
  });
}