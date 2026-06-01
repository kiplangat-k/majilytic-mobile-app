// lib/features/models/otp_model.dart

class OtpModel {
  final String phoneNumber;
  final String otpCode;
  final String contextPurpose;

  const OtpModel({
    required this.phoneNumber,
    required this.otpCode,
    required this.contextPurpose,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': phoneNumber.trim().toLowerCase(),
      'otpCode': otpCode.trim(),
      'contextPurpose': contextPurpose, // e.g., 'REGISTRATION_VERIFY', 'VALVE_RELEASE'
    };
  }
}