// lib/core/constants/api_constants.dart

  class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8080/api/v1';
  static const String billingHistoryEndpoint = '/billing/history'; // 👈 Add this line

  // --- 🌐 Core Host Base URLs ---
  // Use your real local network machine IP address instead!
  // static const String baseUrl = 'http://192.168.2.103:8080/api/v1';

  // --- ⏱️ Transaction Threshold Limits ---
  static const int connectTimeoutSec = 15;
  static const int receiveTimeoutSec = 15;

  // Legacy millisecond configurations (Mapped safely to your timeout integers)
  static const int receiveTimeout = receiveTimeoutSec * 1000;
  static const int connectionTimeout = connectTimeoutSec * 1000;

  // --- 🔒 Authentication Endpoints ---
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';

  // --- 📡 Core Spring Boot Resource Routing Enclaves ---
  static const String dashboardMetricsEndpoint = '/dashboard/metrics';
  static const String walletTopUpEndpoint = '/payments/mpesa/stk-push'; // Triggers your MpesaController
  static const String valveControlEndpoint = '/meters/valve-command';
  static const String telemetryLogEndpoint = '/telemetry/historical-logs';
  static const String billingLedgerEndpoint = '/bills/summary';

  // --- 🗂️ Secondary Feature Module Endpoints ---
  static const String walletBalance = '/wallet/balance';
  static const String walletDeposit = '/wallet/deposit';
  static const String notifications = '/notifications';

  // --- 📂 Header Construction Keys ---
  static const String contentTypeJson = 'application/json';
  static const String acceptJson = 'application/json';
}