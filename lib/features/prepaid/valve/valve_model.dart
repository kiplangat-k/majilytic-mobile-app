// lib/features/prepaid/valve/valve_model.dart

class ValveModel {
  final String meterId;
  final String telemetryTopic;
  final String currentStatus; // 🟢 FIXES: currentStatus getter error
  final DateTime statusLastChanged; // 🟢 FIXES: statusLastChanged getter error

  const ValveModel({
    required this.meterId,
    required this.telemetryTopic,
    required this.currentStatus,
    required this.statusLastChanged,
  });

  factory ValveModel.fromJson(Map<String, dynamic> json) {
    return ValveModel(
      meterId: json['meterId'] ?? json['meter_id'] ?? '',
      telemetryTopic: json['telemetryTopic'] ?? json['telemetry_topic'] ?? '',
      currentStatus: json['currentStatus'] ?? json['status'] ?? 'CLOSED',
      statusLastChanged: json['statusLastChanged'] != null
          ? DateTime.parse(json['statusLastChanged'])
          : DateTime.now(),
    );
  }
}