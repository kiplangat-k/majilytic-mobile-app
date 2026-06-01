// lib/core/services/api_service.dart

import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../errors/app_exception.dart';

class ApiService {
  final ApiClient _apiClient;

  ApiService(this._apiClient);

  /// Standardized wrapper to check and extract valid JSON Map items from raw responses
  Map<String, dynamic> verifyResponseJson(Response response) {
    if (response.data == null) {
      throw const AppException(
        message: 'The remote network node returned an empty execution payload.',
        prefix: 'Empty Payload Trace',
        code: 204,
      );
    }

    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }

    throw const AppException(
      message: 'Unexpected network serialization: Response data format must be a structured JSON Map.',
      prefix: 'Serialization Exception',
      code: 500,
    );
  }

  /// Exposes the basic ApiClient layout to extensions
  ApiClient get client => _apiClient;
}