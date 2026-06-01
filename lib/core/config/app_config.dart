// lib/core/config/app_config.dart

import 'env_config.dart';

class AppConfig {
  final String appName = 'Majilytics';
  final String appVersion = '1.0.0';
  final String buildNumber = '1';

  final EnvConfig env;

  AppConfig({required this.env});

  /// Evaluates whether the application is currently executing inside a Dev sandbox
  bool get isDevelopment => env.environment == AppEnvironment.development;

  /// Evaluates whether production security policies should be enforced
  bool get isProduction => env.environment == AppEnvironment.production;
}