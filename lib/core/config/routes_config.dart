// lib/core/config/routes_config.dart

import 'package:flutter/material.dart';
import '../../features/screens/login_screen.dart';

// 🟢 FIXED: Import the specific, modular dashboard role screens
import '../../features/dashboard/tenant_dashboard_screen.dart';
import '../../features/dashboard/landlord_dashboard_screen.dart';
import '../../features/dashboard/admin_dashboard_screen.dart';

class RoutesConfig {
  static const String login = '/';

  // 🟢 FIXED: Defined distinct role routing strings matching your login logic
  static const String tenantDashboard = '/tenant_dashboard';
  static const String landlordDashboard = '/landlord_dashboard';
  static const String adminDashboard = '/admin_dashboard';

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

    // 🟢 FIXED: Explicitly maps the specific destination views correctly
      case tenantDashboard:
        return MaterialPageRoute(
          builder: (_) => const TenantDashboardScreen(),
          settings: settings,
        );
      case landlordDashboard:
        return MaterialPageRoute(
          builder: (_) => const LandlordDashboardScreen(),
          settings: settings,
        );
      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const AdminDashboardScreen(),
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