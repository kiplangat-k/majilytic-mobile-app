// features/dashboard/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_provider.dart';
import 'dashboard_metrics.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Safely trigger data fetching once when the dashboard mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchSystemState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final data = provider.metrics;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      // --- 🔷 TOP APP BAR WITH PROFILE ACTION & BACK ARROW ---
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1), // Deep navy primary brand color
        elevation: 2,
        automaticallyImplyLeading: false, // Prevents Flutter from overriding our custom leading widget

        // 🟢 FIXED/ADDED: Custom white back arrow explicitly configured to return to the Login screen
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () {
            // Using pushReplacementNamed ensures the user cannot back-button back into the dashboard without re-authenticating
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),

        // 🟢 FIXED: Kept title perfectly centered on all viewports
        centerTitle: true,
        title: const Text(
          'Majilytic Dashboard',
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

      // --- ⚙️ SYSTEM STATE LAYOUT DISPATCHER ---
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D47A1)))
          : provider.errorMessage.isNotEmpty
          ? _buildErrorScreen(provider.errorMessage)
          : RefreshIndicator(
        onRefresh: () => context.read<DashboardProvider>().fetchSystemState(),
        color: const Color(0xFF0D47A1),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- METADATA HEADER BANNER ---
              if (data != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${data.fullName}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Meter Connected: ${data.meterId}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],

              // --- 🎛️ THE GRID CONTAINER MATRIX ---
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.0,
                children: [
                  _buildModuleCard(
                    context: context,
                    title: 'Wallet Engine',
                    icon: Icons.account_balance_wallet,
                    route: '/wallet',
                    badgeValue: data != null ? 'KES ${data.currentWalletBalance.toStringAsFixed(0)}' : null,
                  ),
                  _buildModuleCard(
                    context: context,
                    title: 'Billing Ledger',
                    icon: Icons.receipt_long,
                    route: '/billing',
                    badgeValue: data != null && data.outstandingBillAmount > 0
                        ? 'Due: KES ${data.outstandingBillAmount.toStringAsFixed(0)}'
                        : null,
                  ),
                  _buildModuleCard(
                    context: context,
                    title: 'Valve Operations',
                    icon: Icons.tune,
                    route: '/valve',
                    badgeValue: data?.activeValveStatus ?? 'UNKNOWN',
                    badgeColor: data?.activeValveStatus == 'OPEN' ? Colors.green : Colors.red,
                  ),
                  _buildModuleCard(
                    context: context,
                    title: 'Telemetry Logs',
                    icon: Icons.analytics,
                    route: '/telemetry',
                    badgeValue: data != null ? '${data.latestMeterReading.toStringAsFixed(1)} L' : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // 📐 MODULAR INFRASTRUCTURE WIDGET GENERATORS
  // =========================================================================
  Widget _buildModuleCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String route,
    String? badgeValue,
    Color? badgeColor,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 42, color: const Color(0xFF1E293B)),
              const SizedBox(height: 12),

              // Module Title Label
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87
                ),
              ),

              // Live Metric Subtext Data Node
              if (badgeValue != null) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? const Color(0xFF0D47A1)).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeValue,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: badgeColor ?? const Color(0xFF0D47A1),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
            const SizedBox(height: 14),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<DashboardProvider>().fetchSystemState(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
              label: const Text('Retry Connection', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}