// lib/features/models/user_model.dart

class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? accountNo;
  final bool isVerified;
  final String systemRole;
  final String role;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.accountNo,
    required this.isVerified,
    required this.systemRole,
    required this.role, // 👈 Required by the constructor
  });

  /// Safely maps Postgres table columns parsed through Spring Boot JSON properties
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone_number'] ?? '',
      accountNo: json['accountNo'] ?? json['account_no'],
      isVerified: json['isVerified'] ?? json['is_verified'] ?? false,
      systemRole: json['systemRole'] ?? json['system_role'] ?? 'CLIENT',
      // 🟢 FIXED: Added the missing initialization value parameter here
      role: json['role'] ?? json['systemRole'] ?? 'CLIENT',
    );
  }

  /// Converts properties into a JSON map payload
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'accountNo': accountNo,
      'isVerified': isVerified,
      'systemRole': systemRole,
      'role': role, // 🟢 Added to payload
    };
  }

  @override
  String toString() => 'UserModel(id: $id, name: $fullName, role: $role, verified: $isVerified)';
}