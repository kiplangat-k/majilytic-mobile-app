// lib/features/dashboard/admin_dashboard_screen.dart

import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

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
        title: const Text('Admin System Portal', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('System Administration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('Global configurations, scheduling nodes, and macro meter parameters.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),

          // Infrastructure Summary Indicators
          _buildSystemStatusTile('Automated Billing Cycle', 'Scheduled (00:00 First of Month)', Icons.schedule, Colors.green),
          _buildSystemStatusTile('Database Cluster Status', 'Active (PostgreSQL Cloud)', Icons.dns, Colors.blue),
          _buildSystemStatusTile('Active Gateways Connection', 'Fully Operational', Icons.router, Colors.green),
          const SizedBox(height: 24),

          const Text('Global Utility Operations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.ad_units, color: Color(0xFF0D47A1)),
            title: const Text('Smart Meter Registrations'),
            subtitle: const Text('Provision and link new smart physical hardware units'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.analytics, color: Color(0xFF0D47A1)),
            title: const Text('System-wide Telemetry Metrics'),
            subtitle: const Text('Access flow rate metrics, logs, and audit data directly'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/telemetry'),
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings, color: Color(0xFF0D47A1)),
            title: const Text('Authority Configuration Control'),
            subtitle: const Text('Assign roles and manage cross-system account permissions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSystemStatusTile(String title, String subtitle, IconData icon, Color color) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}