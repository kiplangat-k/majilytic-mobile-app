// lib/features/postpaid/billing/billing_provider.dart

import 'package:flutter/material.dart';
import 'billing_model.dart';
import 'billing_service.dart';
import '../../../core/errors/errors_handler.dart';

class BillingProvider extends ChangeNotifier {
  final BillingService _billingService;

  BillingProvider(this._billingService);

  List<BillingModel> _statements = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BillingModel> get statements => _statements;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Loads account statements into memory from the server
  Future<void> loadBillingData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _statements = await _billingService.fetchAccountStatements();
    } catch (e) {
      _errorMessage = ErrorsHandler.extractUserFriendlyMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Processes payments against selected targets
  Future<bool> settleBill(String billId, double amount) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _billingService.triggerBillSettlement(billId, amount);
      if (success) {
        await loadBillingData(); // Silently pull down up-to-date data states
      }
      return success;
    } catch (_) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}