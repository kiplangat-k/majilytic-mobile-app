// lib/features/prepaid/valve/valve_service.dart

import '../../../core/services/api_service.dart';
import 'valve_model.dart';

class ValveService extends ApiService {
  ValveService(super.apiClient);

  /// Retrieves the remote telemetry status block of the localized solenoid valve node
  Future<ValveModel> fetchCurrentValveState() async {
    try {
      final response = await client.get('/api/v1/prepaid/valve/status');
      final verifiedMap = verifyResponseJson(response);
      return ValveModel.fromJson(verifiedMap);
    } catch (e) {
      rethrow;
    }
  }

  /// Pushes target control signals down to your IoT MQTT Broker pipeline
  Future<ValveModel> transmitValveControlSignal(bool openSignal) async {
    try {
      final response = await client.post(
        '/api/v1/prepaid/valve/control',
        data: {'command': openSignal ? 'OPEN' : 'CLOSE'},
      );
      final verifiedMap = verifyResponseJson(response);
      return ValveModel.fromJson(verifiedMap);
    } catch (e) {
      rethrow;
    }
  }
}