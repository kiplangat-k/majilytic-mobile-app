// lib/core/services/notification_service.dart

import 'api_service.dart';
import '../constants/api_constants.dart';

class NotificationService extends ApiService {
  NotificationService(super.apiClient);

  /// Fetches system alert logs dispatched to a client account
  Future<List<Map<String, dynamic>>> fetchAccountNotifications() async {
    try {
      final response = await client.get(ApiConstants.notifications);

      if (response.data is List) {
        return List<Map<String, dynamic>>.from(
          (response.data as List).map((item) => item as Map<String, dynamic>),
        );
      }

      final verifiedMap = verifyResponseJson(response);
      final alertDataList = verifiedMap['notifications'] ?? verifiedMap['data'] ?? [];
      return List<Map<String, dynamic>>.from(alertDataList);
    } catch (e) {
      return [];
    }
  }
}