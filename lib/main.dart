// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- FEATURE ROUTED USER INTERFACE SCREENS ---
import 'features/screens/login_screen.dart';
import 'features/screens/profile_screen.dart';
import 'features/screens/register_screen.dart';
import 'features/screens/splash_screen.dart';
import 'features/screens/otp_verification_screen.dart';
import 'features/screens/forgot_password_screen.dart';
import 'features/screens/reset_password_screen.dart';

// --- SERVICE LOCATOR DEPENDENCY ENGINE ---
import 'core/config/dependency_injection.dart';

// --- CORE FRAMEWORK STACK IMPORTS ---
import 'core/theme/light_theme.dart';
import 'core/theme/dark_theme.dart';

// --- APP STATE ENGINE MANAGEMENT PROVIDERS ---
import 'features/providers/auth_provider.dart';
import 'features/providers/session_provider.dart';
import 'features/prepaid/wallet/wallet_provider.dart';
import 'features/postpaid/billing/billing_provider.dart';
import 'features/postpaid/telemetry/telemetry_provider.dart';
import 'features/prepaid/valve/valve_provider.dart';

// --- FEATURE ROUTED USER INTERFACE COMPONENTS ---
import 'features/postpaid/billing/billing_screen.dart';
import 'features/postpaid/telemetry/telemetry_screen.dart';
import 'features/prepaid/valve/valve_screen.dart';
import 'features/prepaid/wallet/wallet_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.initializeDependencies();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => locator<SessionProvider>()..readCachedUserSession()),
        ChangeNotifierProvider(create: (_) => locator<WalletProvider>()),
        ChangeNotifierProvider(create: (_) => locator<BillingProvider>()),
        ChangeNotifierProvider(create: (_) => locator<TelemetryProvider>()),
        ChangeNotifierProvider(create: (_) => locator<ValveProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Majilytic Smart Utilities',
      debugShowCheckedModeBanner: false,

      theme: LightTheme.data,
      darkTheme: DarkTheme.data,
      themeMode: ThemeMode.system,

      // --- GLOBAL ROUTING ENGINE ---
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),

        // 🟢 ADDED: Dynamic target dashboard strings registered exactly for authority routing
        '/tenant_dashboard': (context) => const TenantDashboardScreen(),
        '/landlord_dashboard': (context) => const LandlordDashboardScreen(),
        '/admin_dashboard': (context) => const AdminDashboardScreen(),

        // Fallback target points straight to your primary grid view dashboard layout
        '/dashboard': (context) => const DashboardScreen(),

        '/wallet': (context) => const WalletScreen(),
        '/billing': (context) => const BillingScreen(),
        '/telemetry': (context) => const TelemetryScreen(),
        '/valve': (context) => const ValveScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

/// =========================================================================
/// 🛡️ COMPILATION BOUNDARY SAFEGUARDS: BUILT-IN APPLICATION VIEW SCREENS
/// =========================================================================

// 🟢 NEW: Explicit dashboard components mapped cleanly to prevent compilation errors
class TenantDashboardScreen extends StatelessWidget {
  const TenantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardScreen(); // Renders the default operational panel for tenants
  }
}

class LandlordDashboardScreen extends StatelessWidget {
  const LandlordDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Landlord Dashboard')),
      body: const Center(
        child: Text('Property Management & Utility Tracking Overview'),
      ),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin System Portal')),
      body: const Center(
        child: Text('Global System Configuration & Smart Telemetry Analytics'),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Majilytic Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _card(context, 'Wallet Engine', Icons.account_balance_wallet, '/wallet'),
          _card(context, 'Billing Ledger', Icons.receipt_long, '/billing'),
          _card(context, 'Valve Operations', Icons.tune, '/valve'),
          _card(context, 'Telemetry Logs', Icons.analytics, '/telemetry'),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, String title, IconData icon, String route) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon, size: 40), Text(title)],
        ),
      ),
    );
  }
}

class PrepaidScreen extends StatelessWidget {
  const PrepaidScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Prepaid')));
}

class PostpaidScreen extends StatelessWidget {
  const PostpaidScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Postpaid')));
}