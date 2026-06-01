// lib/core/config/env_config.dart

enum AppEnvironment { development, staging, production }

class EnvConfig {
  final AppEnvironment environment;
  final String apiBaseUrl;
  final int receiveTimeoutMilliseconds;
  final int connectionTimeoutMilliseconds;

  EnvConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.receiveTimeoutMilliseconds = 15000,
    this.connectionTimeoutMilliseconds = 15000,
  });

  /// Factory instance configuration matching your local system setup
  factory EnvConfig.development() {
    return EnvConfig(
      environment: AppEnvironment.development,
      // 🟢 10.0.2.2 maps directly to local 127.0.0.1 loopback via Android Emulators
      apiBaseUrl: 'http://127.0.0.1:8080/api/v1',
    );
  }

  factory EnvConfig.staging() {
    return EnvConfig(
      environment: AppEnvironment.staging,
      apiBaseUrl: 'https://staging-api.majilytics.io/api/v1',
    );
  }

  factory EnvConfig.production() {
    return EnvConfig(
      environment: AppEnvironment.production,
      apiBaseUrl: 'https://api.majilytics.io/api/v1',
    );
  }
}