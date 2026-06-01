// lib/core/network/network_exceptions.dart
import 'package:flutter/foundation.dart'; // 👈 Exposes debugPrint
import 'package:dio/dio.dart';
import '../errors/app_exception.dart';
import '../errors/auth_exception.dart';
import '../errors/network_exception.dart';
import '../errors/validation_exception.dart';

class NetworkExceptions {
  NetworkExceptions._();

  /// Evaluates and unifies raw network errors into clear system exceptions
  static AppException handleDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ConnectionTimeoutException();

      case DioExceptionType.badResponse:
        final response = dioException.response;
        final int statusCode = response?.statusCode ?? 500;

        // Safely extract backend failure messages if present
        String errorMessage = 'Server infrastructure error';
        Map<String, List<String>> validationMatrix = {};

        if (response?.data != null) {
          if (response!.data is Map) {
            errorMessage = response.data['message'] ?? response.data['error'] ?? errorMessage;

            // Extract Spring Boot validation constraints if code is 422
            if (statusCode == 422 && response.data['errors'] != null) {
              try {
                final rawErrors = response.data['errors'] as Map;
                validationMatrix = rawErrors.map((k, v) => MapEntry(k.toString(), List<String>.from(v)));
              } catch (_) {}
            }
          } else if (response.data is String) {
            errorMessage = response.data;
          }
        }

        switch (statusCode) {
          case 400:
            return AppException(message: errorMessage, prefix: 'Bad Request Parameter', code: 400);
          case 401:
          case 403:
            return AuthException(message: errorMessage, code: statusCode);
          case 422:
            return ValidationException(message: errorMessage, errors: validationMatrix);
          case 404:
            return AppException(message: errorMessage, prefix: 'Resource Locator Index Empty', code: 404);
          default:
            return FetchDataException(details: 'Status code received: $statusCode. Body: $errorMessage');
        }

      case DioExceptionType.cancel:
        return const AppException(message: 'Request pipeline processing aborted locally.', prefix: 'Operation Cancelled');

      case DioExceptionType.connectionError:
        return const NetworkException(message: 'No active connection to the smart utility server cluster found.', code: 503);

      case DioExceptionType.unknown:
      default:
        return FetchDataException(details: dioException.message ?? 'Unknown lower transport boundary fault.');
    }
  }
}