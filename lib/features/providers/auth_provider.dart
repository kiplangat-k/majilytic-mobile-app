// lib/features/providers/auth_provider.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_api_service.dart';
import '../services/token_storage_service.dart';
import '../../../core/errors/errors_handler.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApiService _authService;
  final TokenStorageService _tokenStorageService;

  // Constructor explicitly accepting the correct Service types
  AuthProvider(this._authService, this._tokenStorageService);

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // --- PUBLIC STATE ENGINE ACCESSORS ---
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Convenience getters for user details in UI widgets
  String? get accountNo => _currentUser?.accountNo;

  // 🟢 SAFETIED GETTER: Always returns UPPERCASE ('TENANT', 'ADMIN', 'LANDLORD') to match navigation logic
  String get userRole => (_currentUser?.role ?? 'TENANT').toUpperCase();

  /// Handles complete authentication orchestration pipeline using credentials
  Future<bool> loginUser({
    required String phoneNumber,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Invoke the API client service layer pipeline execution
      final authResponse = await _authService.authenticate(
        phoneNumber: phoneNumber,
        password: password,
      );

      // 2. Cache down the JWT authorization payload string locally
      await _tokenStorageService.saveAccessToken(authResponse.token);

      // 3. Bind the active user model object profile context
      _currentUser = authResponse.user;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      _errorMessage = ErrorsHandler.extractUserFriendlyMessage(error);
      notifyListeners();
      return false;
    }
  }

  /// Registers a brand new client credential profile structure onto the server
  Future<bool> registerUser({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String accountNumber,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        accountNumber: accountNumber,
        role: role,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      _errorMessage = ErrorsHandler.extractUserFriendlyMessage(error);
      notifyListeners();
      return false;
    }
  }

  /// Wipes active token keys from persistent storage nodes and flushes runtime models
  Future<void> executeLogoutSequence() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _tokenStorageService.clearSessionData();
      _currentUser = null;
      _errorMessage = null;
    } catch (error) {
      _errorMessage = ErrorsHandler.extractUserFriendlyMessage(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear runtime errors safely without dropping current user structural mappings
  void clearErrorState() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}

// --- SUPPORTING STRUCTURES ---

/// Helper structure for matching backend payload responses
class AuthResponse {
  final String token;
  final UserModel user;
  const AuthResponse({required this.token, required this.user});
}

/// Fallback extension ensuring contract requirements are satisfied at compile time.
extension AuthApiServiceExtension on AuthApiService {
  Future<AuthResponse> authenticate({
    required String phoneNumber,
    required String password,
  }) async {
    throw UnimplementedError("Please implement authenticate() inside auth_api_service.dart");
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String accountNumber,
    required String role,
  }) async {
    throw UnimplementedError("Please implement register() inside auth_api_service.dart");
  }
}