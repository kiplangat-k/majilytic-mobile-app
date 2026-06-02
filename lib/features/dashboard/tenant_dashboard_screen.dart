// lib/features/dashboard/tenant_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_provider.dart';

class TenantDashboardScreen extends StatefulWidget {
  const TenantDashboardScreen({super.key});

  @override
  State<TenantDashboardScreen> createState() => _TenantDashboardScreenState();
}

class _TenantDashboardScreenState extends State<TenantDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Safely trigger data fetching once when the dashboard mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        context.read<DashboardProvider>().fetchSystemState();
      } catch (e) {
        debugPrint("Provider setup warning: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Defensive check: Try to read the provider safely
    DashboardProvider provider;
    try {
      provider = context.watch<DashboardProvider>();
    } catch (e) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Initialization Configuration Missing',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please perform a full Hot Restart (R) to bind the multi-provider system context globally.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final data = provider.metrics;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 2,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        ),
        centerTitle: true,
        title: const Text(
          'Tenant Portal',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white, size: 26),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D47A1)))
          : provider.errorMessage.isNotEmpty
          ? _buildErrorScreen(provider.errorMessage) // Passed message node here
          : RefreshIndicator(
        onRefresh: () => context.read<DashboardProvider>().fetchSystemState(),
        color: const Color(0xFF0D47A1),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Profile Header Banner ---
              Text(
                'Welcome back, ${data?.fullName ?? 'Tenant'}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                'Meter ID: ${data?.meterId ?? 'Syncing...'}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 20),

              // --- Account Profile Details ---
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildInfoTile('Name', data?.fullName ?? 'Loading...', Icons.person_outline),
                      _buildInfoTile('Email', 'info@majilytic.com', Icons.email_outlined),
                      _buildInfoTile('Phone', 'Connected', Icons.phone_android_outlined),
                      _buildInfoTile('A/C No.', data?.meterId ?? 'Syncing...', Icons.account_circle_outlined),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Modules Matrix ---
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildCard(
                    title: 'Wallet Engine',
                    icon: Icons.account_balance_wallet,
                    route: '/wallet',
                    badge: data != null ? 'KES ${data.currentWalletBalance.toStringAsFixed(0)}' : null,
                  ),
                  _buildCard(
                    title: 'Billing Ledger',
                    icon: Icons.receipt_long,
                    route: '/billing',
                    badge: data != null && data.outstandingBillAmount > 0
                        ? 'Due: KES ${data.outstandingBillAmount.toStringAsFixed(0)}'
                        : null,
                  ),
                  _buildCard(
                    title: 'Valve Operations',
                    icon: Icons.tune,
                    route: '/valve',
                    badge: data?.activeValveStatus ?? 'UNKNOWN',
                    badgeColor: data?.activeValveStatus == 'OPEN' ? Colors.green : Colors.red,
                  ),
                  _buildCard(
                    title: 'Telemetry Logs',
                    icon: Icons.analytics,
                    route: '/telemetry',
                    badge: data != null ? '${data.latestMeterReading.toStringAsFixed(1)} L' : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEDF2F7)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                Text(value, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required IconData icon, required String route, String? badge, Color? badgeColor}) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
      ),
      child: InkWell(
        onTap: () {
          try {
            Navigator.pushNamed(context, route);
          } catch (e) {
            debugPrint("Navigation target error: $e");
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF0D47A1)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            if (badge != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (badgeColor ?? const Color(0xFF0D47A1)).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: badgeColor ?? const Color(0xFF0D47A1)),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  // 🟢 FIXED: Enhanced error UI so it tells you exactly what failed instead of a blank panel
  Widget _buildErrorScreen(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              'Telemetry Connection Failed',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              message.isNotEmpty ? message : "Unable to reach Majilytic utility telemetry services.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<DashboardProvider>().fetchSystemState(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
              label: const Text('Retry Connection', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}