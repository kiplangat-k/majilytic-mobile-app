// lib/features/prepaid/wallet/wallet_provider.dart

import 'package:flutter/material.dart';
import 'wallet_model.dart';
import 'wallet_service.dart';
import '../../../core/errors/errors_handler.dart';

class WalletProvider extends ChangeNotifier {
  final WalletService _walletService;

  WalletProvider(this._walletService);

  WalletModel? _wallet;
  bool _isLoading = false;
  String? _errorMessage;

  WalletModel? get wallet => _wallet;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetches fresh customer token balance details from backend services
  Future<void> loadWalletData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _wallet = await _walletService.fetchWalletDetails();
    } catch (e) {
      _errorMessage = ErrorsHandler.extractUserFriendlyMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Triggers transactional logic over API endpoints
  Future<bool> topUpWallet({required String phone, required double amount}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _walletService.initiateStkPush(phone, amount);
      if (success) {
        // Yield operational lag to give STK push and backend processing time to commit to the database
        await Future.delayed(const Duration(seconds: 3));
        await loadWalletData();
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