// lib/features/dashboard/dashboard_provider.dart

import 'package:flutter/material.dart';
import '../../core/services/tenant_api_service.dart';

/// 🏛️ Data Model Footprint mapping cleanly to your Spring Boot DTO properties
class TenantMetrics {
  final String fullName;
  final String meterId;
  final double currentWalletBalance;
  final double outstandingBillAmount;
  final String activeValveStatus;
  final double latestMeterReading;

  TenantMetrics({
    required this.fullName,
    required this.meterId,
    required this.currentWalletBalance,
    required this.outstandingBillAmount,
    required this.activeValveStatus,
    required this.latestMeterReading,
  });

  /// Factory node to dynamically deserialize JSON objects coming from PostgreSQL fields
  factory TenantMetrics.fromJson(Map<String, dynamic> json) {
    return TenantMetrics(
      fullName: json['fullName'] ?? 'Valued Tenant',
      meterId: json['meterId'] ?? 'N/A',
      currentWalletBalance: (json['currentWalletBalance'] ?? 0.0).toDouble(),
      outstandingBillAmount: (json['outstandingBillAmount'] ?? 0.0).toDouble(),
      activeValveStatus: json['activeValveStatus'] ?? 'UNKNOWN',
      latestMeterReading: (json['latestMeterReading'] ?? 0.0).toDouble(),
    );
  }
}

class DashboardProvider extends ChangeNotifier {
  final TenantApiService _tenantApiService;

  DashboardProvider(this._tenantApiService);

  // Private state indicators
  bool _isLoading = false;
  String _errorMessage = '';
  TenantMetrics? _metrics;

  // Public Getters to allow UI layout consumption safely
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  TenantMetrics? get metrics => _metrics;

  /// Executes data stream retrieval against the API pipeline
  Future<void> fetchSystemState() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Force loading spinner layout visibility state

    try {
      final jsonMap = await _tenantApiService.getTenantMetrics();
      _metrics = TenantMetrics.fromJson(jsonMap);
    } catch (error) {
      // Formats the network stack error directly into string for display panels
      _errorMessage = error.toString().replaceAll('Exception:', '').trim();
    } finally {
      _isLoading = false;
      notifyListeners(); // Dismiss loading spinner indicator to show either data or error view
    }
  }
}