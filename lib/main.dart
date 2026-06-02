// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- SERVICE LOCATOR DEPENDENCY ENGINE ---
import 'core/config/dependency_injection.dart';

// --- CORE FRAMEWORK STACK IMPORTS ---
import 'core/theme/light_theme.dart';
import 'core/theme/dark_theme.dart';

// --- FEATURE ROUTED USER INTERFACE SCREENS ---
import 'features/screens/login_screen.dart';
import 'features/screens/register_screen.dart';
import 'features/screens/profile_screen.dart';
import 'features/screens/splash_screen.dart';
import 'features/screens/otp_verification_screen.dart';
import 'features/screens/forgot_password_screen.dart';
import 'features/screens/reset_password_screen.dart';

// --- SEPARATED DEDICATED ROLE DASHBOARDS ---
import 'features/dashboard/tenant_dashboard_screen.dart';
import 'features/dashboard/landlord_dashboard_screen.dart';
import 'features/dashboard/admin_dashboard_screen.dart';

// --- APP STATE ENGINE MANAGEMENT PROVIDERS ---
import 'features/providers/auth_provider.dart';
import 'features/providers/session_provider.dart';
import 'features/dashboard/dashboard_provider.dart';
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
        ChangeNotifierProvider(create: (_) => locator<DashboardProvider>()),
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
        '/forgot-password': (context) => const ForgotPasswordScreen(),

        // Safe targets mapped cleanly to their dedicated modular screens
        '/tenant_dashboard': (context) => const TenantDashboardScreen(),
        '/landlord_dashboard': (context) => const LandlordDashboardScreen(),
        '/admin_dashboard': (context) => const AdminDashboardScreen(),

        '/wallet': (context) => const WalletScreen(),
        '/billing': (context) => const BillingScreen(),
        '/telemetry': (context) => const TelemetryScreen(),
        '/valve': (context) => const ValveScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}