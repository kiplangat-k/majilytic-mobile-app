// lib/features/postpaid/billing/billing_model.dart

import '../../../core/utils/helpers.dart';

class BillingModel {
  final String billId;
  final String accountNo;
  final double amountDue;
  final double consumptionVolume;
  final DateTime billingDate;
  final DateTime dueDate;
  final String paymentStatus;
  final String? invoiceUrl;

  const BillingModel({
    required this.billId,
    required this.accountNo,
    required this.amountDue,
    required this.consumptionVolume,
    required this.billingDate,
    required this.dueDate,
    required this.paymentStatus,
    this.invoiceUrl,
  });

  /// Factory constructor to parse standard relational response payloads from Spring Boot
  factory BillingModel.fromJson(Map<String, dynamic> json) {
    return BillingModel(
      billId: (json['billId'] ?? json['bill_id'] ?? '').toString(),
      accountNo: (json['accountNo'] ?? json['account_no'] ?? 'UNASSIGNED').toString(),
      amountDue: Helpers.safeParseDouble(json['amountDue'] ?? json['amount_due']),
      consumptionVolume: Helpers.safeParseDouble(json['consumptionVolume'] ?? json['consumption_volume']),
      billingDate: json['billingDate'] != null
          ? DateTime.parse(json['billingDate'].toString())
          : DateTime.parse(json['billing_date'] ?? DateTime.now().toIso8601String()),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'].toString())
          : DateTime.parse(json['due_date'] ?? DateTime.now().toIso8601String()),
      paymentStatus: (json['paymentStatus'] ?? json['payment_status'] ?? 'UNPAID').toString().toUpperCase(),
      invoiceUrl: json['invoiceUrl'] ?? json['invoice_url'],
    );
  }

  /// Helper to check if a bill is past its payment threshold
  bool get isOverdue => paymentStatus == 'UNPAID' && DateTime.now().isAfter(dueDate);

  Map<String, dynamic> toJson() {
    return {
      'billId': billId,
      'accountNo': accountNo,
      'amountDue': amountDue,
      'consumptionVolume': consumptionVolume,
      'billingDate': billingDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'paymentStatus': paymentStatus,
      'invoiceUrl': invoiceUrl,
    };
  }
}