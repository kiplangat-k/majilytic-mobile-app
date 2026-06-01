// lib/features/providers/register_provider.dart

import 'package:flutter/material.dart';
import '../services/auth_api_service.dart';
import '../../../core/errors/errors_handler.dart';

class RegisterProvider extends ChangeNotifier {
  final AuthApiService _authService;

  // Constructor explicitly accepting the required API service layer
  RegisterProvider(this._authService);

  bool _isLoading = false;
  String? _errorMessage;
  bool _isRegistrationSuccess = false;

  // --- PUBLIC STATE ACCESSORS ---
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isRegistrationSuccess => _isRegistrationSuccess;

  /// Registers a brand new client account structure directly on the backend server
  Future<bool> registerNewUser({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String accountNumber,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isRegistrationSuccess = false;
    notifyListeners();

    try {
      // Invoke backend client service request execution
      await _authService.register(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        accountNumber: accountNumber,
        role: role,
      );

      _isRegistrationSuccess = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      _isRegistrationSuccess = false;
      _errorMessage = ErrorsHandler.extractUserFriendlyMessage(error);
      notifyListeners();
      return false;
    }
  }

  /// Reset the error and registration tracking states safely
  void resetRegistrationState() {
    _errorMessage = null;
    _isRegistrationSuccess = false;
    notifyListeners();
  }
}