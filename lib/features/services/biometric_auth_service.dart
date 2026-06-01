import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _auth;
  BiometricAuthService(this._auth); // 👈 This constructor matches main.dart
}