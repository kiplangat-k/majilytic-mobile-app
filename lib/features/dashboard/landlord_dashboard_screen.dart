// lib/features/dashboard/landlord_dashboard_screen.dart

import 'package:flutter/material.dart';

class LandlordDashboardScreen extends StatelessWidget {
  const LandlordDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Landlord Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Property Management Portal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('Monitor tenants, water usage telemetry, and total billing aggregates.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // Overview Metric Summaries
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Properties', '12 Units', Icons.domain, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Outstanding Bills', 'KES 42,000', Icons.receipt_long, Colors.red)),
              ],
            ),
            const SizedBox(height: 24),

            // Operational grid cards for landlord functions
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildActionCard(context, 'Manage Tenants', Icons.people_outline, '#'),
                _buildActionCard(context, 'Telemetry Overview', Icons.analytics_outlined, '/telemetry'),
                _buildActionCard(context, 'Global Valve Controls', Icons.tune_outlined, '/valve'),
                _buildActionCard(context, 'Revenue Ledger', Icons.account_balance_wallet_outlined, '/wallet'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String status, IconData icon, Color indicatorColor) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: indicatorColor, size: 28),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(status, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String label, IconData icon, String targetRoute) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: InkWell(
        onTap: () => targetRoute != '#' ? Navigator.pushNamed(context, targetRoute) : null,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: const Color(0xFF0D47A1)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}