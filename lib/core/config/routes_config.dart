// lib/core/config/routes_config.dart

import 'package:flutter/material.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/screens/login_screen.dart';

class RoutesConfig {
  static const String login = '/';
  static const String dashboard = '/dashboard';
  static const String wallet = '/wallet';
  static const String billing = '/billing';
  static const String telemetry = '/telemetry';

  /// Compiles system string paths to structural material page routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );
      case wallet:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Wallet Feature Module'))),
          settings: settings,
        );
      case billing:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Billing Feature Module'))),
          settings: settings,
        );
      case telemetry:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Telemetry Feature Module'))),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route Reference Boundary Error: ${settings.name}')),
          ),
        );
    }
  }
}