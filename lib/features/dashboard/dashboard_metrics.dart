// lib/features/dashboard/dashboard_metrics.dart

class DashboardMetrics {
  final String meterId;
  final String activeValveStatus;
  final String consumptionUnit;
  final double currentWalletBalance;
  final String lastSyncTime;
  final double latestMeterReading;
  final double outstandingBillAmount;

  // Extra fields for complete fallback presentation mappings
  final String fullName;
  final String billStatus;
  final String billDueDate;

  const DashboardMetrics({
    required this.meterId,
    required this.activeValveStatus,
    required this.consumptionUnit,
    required this.currentWalletBalance,
    required this.lastSyncTime,
    required this.latestMeterReading,
    required this.outstandingBillAmount,
    required this.fullName,
    required this.billStatus,
    required this.billDueDate,
  });

  /// Factory mapping constructor to process unified responses seamlessly
  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      meterId: json['meterId'] ?? json['smartMeterNumber'] ?? 'N/A',
      activeValveStatus: json['activeValveStatus'] ?? (json['isValveOpen'] == true ? 'OPEN' : 'CLOSED'),
      consumptionUnit: json['consumptionUnit'] ?? 'Liters',
      currentWalletBalance: (json['currentWalletBalance'] ?? json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      lastSyncTime: json['lastSyncTime'] ?? json['billDueDate'] ?? 'N/A',
      latestMeterReading: (json['latestMeterReading'] ?? json['waterUsageToday'] as num?)?.toDouble() ?? 0.0,
      outstandingBillAmount: (json['outstandingBillAmount'] ?? json['billAmountDue'] as num?)?.toDouble() ?? 0.0,
      fullName: json['fullName'] ?? 'User',
      billStatus: json['billStatus'] ?? 'N/A',
      billDueDate: json['billDueDate'] ?? 'N/A',
    );
  }
}