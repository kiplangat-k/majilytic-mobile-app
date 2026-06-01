// lib/features/models/meter_model.dart

class MeterModel {
  final String id;
  final String meterNumber;
  final double currentReading;
  final double previousReading;
  final double consumptionToday;
  final String status; // e.g., 'ACTIVE', 'SUSPENDED'
  final DateTime? lastUpdatedAt;

  MeterModel({
    required this.id,
    required this.meterNumber,
    required this.currentReading,
    required this.previousReading,
    required this.consumptionToday,
    required this.status,
    this.lastUpdatedAt,
  });

  /// Factory constructor to safely parse incoming Spring Boot JSON data
  factory MeterModel.fromJson(Map<String, dynamic> json) {
    return MeterModel(
      id: json['id']?.toString() ?? '',
      meterNumber: json['meter_number'] ?? json['meterNumber'] ?? 'N/A',
      currentReading: (json['current_reading'] as num?)?.toDouble() ??
          (json['currentReading'] as num?)?.toDouble() ?? 0.0,
      previousReading: (json['previous_reading'] as num?)?.toDouble() ??
          (json['previousReading'] as num?)?.toDouble() ?? 0.0,
      consumptionToday: (json['consumption_today'] as num?)?.toDouble() ??
          (json['consumptionToday'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString().toUpperCase() ?? 'UNKNOWN',
      lastUpdatedAt: json['last_updated_at'] != null || json['lastUpdatedAt'] != null
          ? DateTime.tryParse(json['last_updated_at'] ?? json['lastUpdatedAt'])
          : null,
    );
  }

  /// Converts the model instance back into a map layout for API payload submissions
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meter_number': meterNumber,
      'current_reading': currentReading,
      'previous_reading': previousReading,
      'consumption_today': consumptionToday,
      'status': status,
      'last_updated_at': lastUpdatedAt?.toIso8601String(),
    };
  }
}