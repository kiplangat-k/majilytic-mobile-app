// lib/features/providers/admin_provider.dart
import 'package:flutter/material.dart';
import '../../core/services/admin_api_service.dart';
// import '../services/admin_api_service.dart';
import '../../../core/errors/errors_handler.dart';

class AdminProvider extends ChangeNotifier {
  final AdminApiService _adminService;

  AdminProvider(this._adminService);

  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _adminData;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Map<String, dynamic>? get adminData => _adminData;

  Future<void> fetchAdminSystemState() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final data = await _adminService.fetchAdminMetrics();
      _adminData = data;
    } catch (error) {
      _errorMessage = ErrorsHandler.extractUserFriendlyMessage(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}