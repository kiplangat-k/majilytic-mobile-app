// lib/features/prepaid/valve/valve_provider.dart

import 'package:flutter/material.dart';
import 'valve_model.dart';

class ValveProvider extends ChangeNotifier {
  ValveModel? _valveState;
  bool _isLoading = false;

  ValveModel? get valveState => _valveState;
  bool get isLoading => _isLoading;

  /// 🟢 FIXES: 'loadValveState' isn't defined error
  Future<void> loadValveState() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mock tracking or replace with your direct API service implementation call
      await Future.delayed(const Duration(milliseconds: 600));
      _valveState = ValveModel(
        meterId: "MTR-2026-VALVE",
        telemetryTopic: "majilytic/meters/valve",
        currentStatus: _valveState?.currentStatus ?? "CLOSED",
        statusLastChanged: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Valve State Pull Failure: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🟢 FIXES: 'toggleValveActuation' isn't defined error
  Future<bool> toggleValveActuation(bool openTarget) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate remote backend API or MQTT integration handshake
      await Future.delayed(const Duration(milliseconds: 800));
      _valveState = ValveModel(
        meterId: _valveState?.meterId ?? "MTR-2026-VALVE",
        telemetryTopic: _valveState?.telemetryTopic ?? "majilytic/meters/valve",
        currentStatus: openTarget ? "OPEN" : "CLOSED",
        statusLastChanged: DateTime.now(),
      );
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}