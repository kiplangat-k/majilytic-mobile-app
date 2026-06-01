// lib/core/utils/errors_handler.dart

import 'package:dio/dio.dart';

// 🟢 FIXED: Using absolute package imports to guarantee the compiler finds the files
import 'package:majilytic/core/errors/failure.dart';
import 'package:majilytic/core/errors/network_exception.dart';

class ErrorsHandler {
  /// Parses application errors safely to extract user-friendly messaging strings
  static String extractUserFriendlyMessage(dynamic error) {
    if (error == null) {
      return 'An unexpected error occurred. Please try again.';
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Server connection timed out. Please check your internet connection.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final backendMessage = error.response?.data?['message'];
          if (backendMessage != null) {
            return backendMessage.toString();
          }
          return 'Server error ($statusCode). Please contact support.';
        case DioExceptionType.connectionError:
          return 'Unable to connect to the server. Ensure your backend engine is running.';
        case DioExceptionType.cancel:
          return 'The request was cancelled.';
        default:
          return 'A network error occurred. Please try again.';
      }
    }

    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }

    return error.toString();
  }

  /// Maps custom domain exceptions directly into structured Failure states
  static Failure handle(dynamic exception) {
    if (exception is ConnectionTimeoutException) {
      // 🟢 FIXED: Returned a concrete subclass with a plain positional string argument
      return const ServerFailure("Connection timed out. Please check your internet connection.");
    }

    final String readableMessage = extractUserFriendlyMessage(exception);

    // 🟢 FIXED: Avoided abstract instantiation by returning our ServerFailure subclass positional block
    return ServerFailure(readableMessage);
  }
}

// 🟢 FIXED: Added a concrete subclass extending Failure to bypass abstract restrictions cleanly
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}