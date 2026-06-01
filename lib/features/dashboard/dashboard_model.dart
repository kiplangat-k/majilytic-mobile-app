// features/dashboard/dashboard_model.dart

class DashboardMetrics {
  final String fullName;
  final String smartMeterNumber;
  final double walletBalance;
  final double waterUsageToday;
  final bool isValveOpen;
  final double billAmountDue;
  final String billStatus;
  final String billDueDate;

  DashboardMetrics({
    required this.fullName,
    required this.smartMeterNumber,
    required this.walletBalance,
    required this.waterUsageToday,
    required this.isValveOpen,
    required this.billAmountDue,
    required this.billStatus,
    required this.billDueDate,
  });

  /// Factory constructor to parse incoming backend maps safely into strict Dart types
  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      fullName: json['fullName'] ?? 'User',
      smartMeterNumber: json['smartMeterNumber'] ?? json['meterNumber'] ?? 'N/A',
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      waterUsageToday: (json['waterUsageToday'] as num?)?.toDouble() ?? 0.0,
      isValveOpen: json['isValveOpen'] ?? true,
      billAmountDue: (json['billAmountDue'] as num?)?.toDouble() ?? 0.0,
      billStatus: json['billStatus'] ?? 'N/A',
      billDueDate: json['billDueDate'] ?? 'N/A',
    );
  }

  /// Optional: Converts your client model back into a Map structure
  /// useful for local cache operations or debug testing
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'smartMeterNumber': smartMeterNumber,
      'walletBalance': walletBalance,
      'waterUsageToday': waterUsageToday,
      'isValveOpen': isValveOpen,
      'billAmountDue': billAmountDue,
      'billStatus': billStatus,
      'billDueDate': billDueDate,
    };
  }
}