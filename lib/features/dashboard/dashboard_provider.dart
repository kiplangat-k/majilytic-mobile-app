// lib/features/dashboard/dashboard_provider.dart

import 'package:flutter/material.dart';
// 🟢 FIXED: Change this import to point directly to metrics!
import 'dashboard_metrics.dart';
//import '../services/dashboard_service.dart';
import 'dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService _dashboardService;

  DashboardProvider(this._dashboardService);

  // 🟢 Resolves the type assignment incompatibility barriers cleanly
  DashboardMetrics? _metrics;
  bool _isLoading = false;
  String _errorMessage = '';

  DashboardMetrics? get metrics => _metrics;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchSystemState() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _metrics = await _dashboardService.getDashboardSummaryData();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}