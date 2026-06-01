// lib/features/models/auth_token_model.dart

class AuthTokenModel {
  final String accessToken;
  final String tokenType;
  final int expiresInSeconds;

  const AuthTokenModel({
    required this.accessToken,
    this.tokenType = 'Bearer',
    required this.expiresInSeconds,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['accessToken'] ?? json['token'] ?? '',
      tokenType: json['tokenType'] ?? json['token_type'] ?? 'Bearer',
      expiresInSeconds: json['expiresIn'] ?? json['expires_in'] ?? 86400, // Default to 24hrs fallback
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'tokenType': tokenType,
      'expiresInSeconds': expiresInSeconds,
    };
  }
}