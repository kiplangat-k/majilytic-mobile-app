// lib/features/prepaid/wallet/wallet_model.dart

import '../../../core/utils/helpers.dart';

class WalletModel {
  final String walletId;
  final String accountNo;
  final double currentBalance;
  final DateTime lastTopUpDate;
  final String currency;

  const WalletModel({
    required this.walletId,
    required this.accountNo,
    required this.currentBalance,
    required this.lastTopUpDate,
    this.currency = 'KES',
  });

  /// Maps transactional metrics parsed from PostgreSQL numeric formats via Spring Boot JSON payloads
  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      walletId: (json['walletId'] ?? json['id'] ?? '').toString(),
      accountNo: (json['accountNo'] ?? json['account_no'] ?? 'UNASSIGNED').toString(),
      currentBalance: Helpers.safeParseDouble(json['currentBalance'] ?? json['balance']),
      lastTopUpDate: json['lastTopUpDate'] != null
          ? DateTime.parse(json['lastTopUpDate'].toString())
          : (json['last_topup'] != null ? DateTime.parse(json['last_topup'].toString()) : DateTime.now()),
      currency: json['currency'] ?? 'KES',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'walletId': walletId,
      'accountNo': accountNo,
      'currentBalance': currentBalance,
      'lastTopUpDate': lastTopUpDate.toIso8601String(),
      'currency': currency,
    };
  }
}