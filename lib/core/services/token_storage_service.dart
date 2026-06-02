// lib/features/services/token_storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  // Static key allocations to prevent string typos across runtime writes
  static const String _tokenKey = 'auth_access_token';
  static const String _userRoleKey = 'auth_user_role';
  static const String _phoneNumberKey = 'auth_user_phone';

  /// Saves the active JWT access token string into persistent storage nodes
  Future<void> saveAccessToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Retrieves the cached authorization string token for API endpoint headers
  Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Check helper to determine if an authorization token exists locally
  Future<bool> hasToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  /// Caches the active user authority role ('TENANT', 'LANDLORD', 'ADMIN')
  Future<void> saveUserRole(String role) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, role.toUpperCase());
  }

  /// Retrieves the logged-in user's assigned permission level
  Future<String?> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  /// Caches down the phone identifier credential for persistent session tracking
  Future<void> saveUserPhone(String phone) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneNumberKey, phone);
  }

  /// Reads back the locked-in user account phone identification string
  Future<String?> getUserPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneNumberKey);
  }

  /// Wipes all active runtime authorization tokens and session keys completely.
  /// Used heavily during executeLogoutSequence() inside AuthProvider.
  Future<void> clearSessionData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_phoneNumberKey);
  }
}