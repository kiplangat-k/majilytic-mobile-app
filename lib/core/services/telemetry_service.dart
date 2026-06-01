// lib/core/services/telemetry_service.dart

import 'api_service.dart';
import '../constants/api_constants.dart';

class TelemetryService extends ApiService {
  TelemetryService(super.apiClient);

  /// Pulls device metrics for an active hardware water line
  Future<List<Map<String, dynamic>>> pullHistoricalMeterLogs(String meterId) async {
    try {
      final response = await client.get(
        ApiConstants.telemetryLogEndpoint,
        queryParameters: {'meterId': meterId},
      );

      if (response.data is List) {
        return List<Map<String, dynamic>>.from(
          (response.data as List).map((item) => item as Map<String, dynamic>),
        );
      }

      final verifiedMap = verifyResponseJson(response);
      final rawLogsList = verifiedMap['logs'] ?? verifiedMap['data'] ?? [];
      return List<Map<String, dynamic>>.from(rawLogsList);
    } catch (e) {
      return [];
    }
  }
}