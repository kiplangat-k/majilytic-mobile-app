// lib/features/postpaid/telemetry/telemetry_model.dart

import '../../../core/utils/helpers.dart';

class TelemetryModel {
  final String logId;
  final String meterId;
  final double currentFlowRate;
  final double cumulativeVolume;
  final double batteryVoltage;
  final int signalStrength;
  final DateTime capturedAt;

  const TelemetryModel({
    required this.logId,
    required this.meterId,
    required this.currentFlowRate,
    required this.cumulativeVolume,
    required this.batteryVoltage,
    required this.signalStrength,
    required this.capturedAt,
  });

  /// Extracts telemetry datasets parsed through your custom hardware schema indexes
  factory TelemetryModel.fromJson(Map<String, dynamic> json) {
    return TelemetryModel(
      logId: (json['logId'] ?? json['id'] ?? '').toString(),
      meterId: (json['meterId'] ?? json['meter_id'] ?? 'UNKNOWN').toString(),
      currentFlowRate: Helpers.safeParseDouble(json['currentFlowRate'] ?? json['flow_rate']),
      cumulativeVolume: Helpers.safeParseDouble(json['cumulativeVolume'] ?? json['cumulative_volume']),
      batteryVoltage: Helpers.safeParseDouble(json['batteryVoltage'] ?? json['battery_voltage']),
      signalStrength: (json['signalStrength'] ?? json['rssi'] ?? 0) as int,
      capturedAt: json['capturedAt'] != null
          ? DateTime.parse(json['capturedAt'].toString())
          : DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logId': logId,
      'meterId': meterId,
      'currentFlowRate': currentFlowRate,
      'cumulativeVolume': cumulativeVolume,
      'batteryVoltage': batteryVoltage,
      'signalStrength': signalStrength,
      'capturedAt': capturedAt.toIso8601String(),
    };
  }
}