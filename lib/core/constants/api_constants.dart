class ApiConstants {
  // If testing via Android Emulator, use 10.0.2.2 to point to your Spring Boot localhost (8080)
  // If testing on a real device, change this to your machine's local IP address (e.g., 192.168.1.50)
 // static const String baseUrl = 'http://10.0.2.2:8080/api/v1';
 // static const String baseUrl = 'http://192.168.0.104:8080/api/v1';
  static const String baseUrl = 'http://127.0.0.1:8080/api/v1';
  //  Use your real local network machine IP address instead!
  //static const String baseUrl = 'http://192.168.2.103:8080/api/v1';

  // Network configurations
  static const int receiveTimeout = 15000;
  static const int connectionTimeout = 15000;

  // Authentication Endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';

  // Feature Endpoints
  static const String walletBalance = '/wallet/balance';
  static const String walletDeposit = '/wallet/deposit'; // Triggers your MpesaController
  static const String notifications = '/notifications';
}