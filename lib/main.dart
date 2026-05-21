import 'package:flutter/material.dart';
import 'package:majilytic/presentation/auth/login_screen.dart';
import 'package:majilytic/presentation/auth/register_screen.dart';
import 'package:majilytic/presentation/billing/billing_screen.dart';
import 'package:majilytic/presentation/profile/profile_screen.dart';

// 🌟 IMPORTANT: Make sure this import matches the actual file location of your new dynamic dashboard!
import 'package:majilytic/presentation/dashboard/dashboard_screen.dart';

void main() {
  // Ensure Flutter bindings are initialized before any async SDK or backend setup
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Majilytic Utilities',
      debugShowCheckedModeBanner: false,

      // Light & Dark theme layers linked to your seed configurations
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066CC), // Primary Brand Color matching your login UI
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066CC),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,

      // App launches directly into Sign In view
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(), // 🌟 Routes to your stateful smart water component
        '/wallet': (context) => const WalletScreen(),       // Routes to separate screen file as needed
        '/billing': (context) => const BillingScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

/// =========================================================================
/// WALLET PLACEHOLDER
/// (Move this to lib/presentation/wallet/wallet_screen.dart whenever you want)
/// =========================================================================
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Available Balance',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const Text(
              'KES 0.00',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Triggering payment API...')),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Deposit Funds'),
            ),
          ],
        ),
      ),
    );
  }
}