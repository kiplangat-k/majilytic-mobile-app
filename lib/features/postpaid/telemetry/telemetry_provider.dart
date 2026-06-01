// lib/features/postpaid/telemetry/telemetry_provider.dart

import 'package:flutter/material.dart';
import 'telemetry_model.dart';
import 'telemetry_service.dart';
import '../../../core/errors/errors_handler.dart';

class TelemetryProvider extends ChangeNotifier {
  final TelemetryService _telemetryService;

  TelemetryProvider(this._telemetryService);

  List<TelemetryModel> _logs = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TelemetryModel> get logs => _logs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetches historical metrics from physical utility hardware nodes
  Future<void> loadTelemetryData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _logs = await _telemetryService.fetchMeterTelemetryLogs();
    } catch (e) {
      // 🟢 RESOLVED: Static method bind successfully evaluates here
      _errorMessage = ErrorsHandler.extractUserFriendlyMessage(e);
    } finally {
      _isLoading = false; // Turn off your circular progress indicator spinner
      notifyListeners();
    }
  }
}