// lib/core/constants/app_strings.dart

class AppStrings {
  AppStrings._();

  // --- App Identity Headlines ---
  static const String appName = 'Majilytics';
  static const String appSubHeadline = 'Smart Water Infrastructure Suite';

  // --- Functional Sub-Module Headings ---
  static const String prepaidModeHeader = 'Prepaid Service Mode';
  static const String postpaidModeHeader = 'Postpaid Service Mode';
  static const String selectBranchPrompt = 'Select Operational Mode Branch';

  // --- Feature Metrics Copy Labels ---
  static const String smartMeterLabel = 'Smart Meter ID';
  static const String walletModuleLabel = 'Wallet Module (payments, transactions)';
  static const String valveModuleLabel = 'Valve Module (meters, valve_commands)';
  static const String billingModuleLabel = 'Billing Module (bills)';
  static const String telemetryModuleLabel = 'Telemetry Module (meter_telemetry)';

  // --- Fallback & Synchronization Fault Notifications ---
  static const String syncFailedMessage = 'Failed to synchronize individual controller components: Session expired or unauthorized.';
  static const String retryConnectionButton = 'Retry Connection';
  static const String loadSessionHint = 'Tap a service option node to map live hardware controllers.';
}