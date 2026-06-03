import 'package:flutter/material.dart';
import '../../core/services/admin_api_service.dart';

class AdminProvider with ChangeNotifier {
  final AdminApiService _apiService;

  Map<String, dynamic>? _dashboardData;
  bool _isLoading = false;
  String? _errorMessage;

  AdminProvider(this._apiService);

  Map<String, dynamic>? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getAdminMetrics() async {
    _setLoading(true);
    try {
      _dashboardData = await _apiService.fetchSystemOverview();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> moderateUser(String userId, bool action) async {
    _setLoading(true);
    try {
      await _apiService.updateUserStatus(userId, action);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}