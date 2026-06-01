// lib/core/utils/logger.dart

import 'package:flutter/foundation.dart';

class Logger {
  Logger._();

  /// Prints structured debug statements during development builds
  static void d(String message, {String? tag}) {
    if (kDebugMode) {
      _printLog(level: 'DEBUG', tag: tag ?? 'APP', message: message);
    }
  }

  /// Prints critical infrastructure errors or backend connectivity failures
  static void e(String message, {dynamic error, StackTrace? stackTrace, String? tag}) {
    _printLog(level: 'ERROR', tag: tag ?? 'SYS', message: message);
    if (error != null && kDebugMode) {
      print('↳ Error Detail: $error');
    }
    if (stackTrace != null && kDebugMode) {
      print('↳ StackTrace:\n$stackTrace');
    }
  }

  /// Prints telemetry data logs received from live devices
  static void iot(String topic, String message) {
    if (kDebugMode) {
      _printLog(level: '📶 MQTT', tag: 'TELEMETRY', message: '[$topic] -> $message');
    }
  }

  static void _printLog({
    required String level,
    required String tag,
    required String message,
  }) {
    final timestamp = DateTime.now().toIso8601String().split('T').last.substring(0, 12);
    print('[$level][$timestamp][$tag] $message');
  }
}