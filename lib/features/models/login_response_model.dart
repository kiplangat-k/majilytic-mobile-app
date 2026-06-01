// lib/features/models/login_response_model.dart

import 'user_model.dart';
import 'auth_token_model.dart';

class LoginResponseModel {
  final AuthTokenModel token;
  final UserModel user;
  final String message;

  const LoginResponseModel({
    required this.token,
    required this.user,
    required this.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    // Accommodates direct payloads or data encapsulation wrappers safely
    final targetSource = json['data'] != null ? json['data'] as Map<String, dynamic> : json;

    return LoginResponseModel(
      token: AuthTokenModel.fromJson(targetSource),
      user: UserModel.fromJson(targetSource['user'] as Map<String, dynamic>),
      message: json['message'] ?? 'Authentication established successfully.',
    );
  }
}