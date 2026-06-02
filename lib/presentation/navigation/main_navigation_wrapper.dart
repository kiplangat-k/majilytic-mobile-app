import 'package:flutter/material.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/prepaid/wallet/wallet_screen.dart';
import '../../features/postpaid/billing/billing_screen.dart';
import '../../features/screens/profile_screen.dart';

// Placeholder stubs for the remaining modular units in your flowchart
class PrepaidModuleStub extends StatelessWidget { const PrepaidModuleStub({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Prepaid Module (Meter Validation)'))); }
class PostpaidModuleStub extends StatelessWidget { const PostpaidModuleStub({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Postpaid Module (Bill Validation)'))); }
class SmartMeterModuleStub extends StatelessWidget { const SmartMeterModuleStub({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Smart Meter Module (Live Usage)'))); }

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  // The 6 main pillars exactly as structured in the chart layout
  final List<Widget> _modules = [
    //const DashboardScreen(),       // Index 0: Dashboard Module
    const PrepaidModuleStub(),     // Index 1: Prepaid Module
    const PostpaidModuleStub(),    // Index 2: Postpaid Module
    const SmartMeterModuleStub(),  // Index 3: Smart Meter Module
    const WalletScreen(),          // Index 4: Wallet Module
    const ProfileScreen(),         // Index 5: Profile Module
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _modules, // Keeps the state of screens alive when switching tabs
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed, // Forces all 6 labels to show cleanly
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Prepaid'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Postpaid'),
          BottomNavigationBarItem(icon: Icon(Icons.speed), label: 'Meter'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}