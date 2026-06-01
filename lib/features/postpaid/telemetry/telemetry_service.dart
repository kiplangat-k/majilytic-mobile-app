// lib/features/postpaid/telemetry/telemetry_service.dart

import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';
import 'telemetry_model.dart';

class TelemetryService extends ApiService {
  TelemetryService(super.apiClient);

  /// Pulls live time-series tracking updates for an assigned meter hardware device
  Future<List<TelemetryModel>> fetchMeterTelemetryLogs() async {
    try {
      final response = await client.get(ApiConstants.telemetryLogEndpoint);

      if (response.data is List) {
        return (response.data as List)
            .map((json) => TelemetryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      final verifiedMap = verifyResponseJson(response);
      final rawList = verifiedMap['telemetry'] ?? verifiedMap['data'] ?? [];
      return (rawList as List)
          .map((json) => TelemetryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}