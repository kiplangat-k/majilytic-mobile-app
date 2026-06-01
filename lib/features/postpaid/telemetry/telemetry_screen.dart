// lib/features/postpaid/telemetry/telemetry_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'telemetry_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/constants/app_colors.dart';

class TelemetryScreen extends StatefulWidget {
  const TelemetryScreen({super.key});

  @override
  State<TelemetryScreen> createState() => _TelemetryScreenState();
}

class _TelemetryScreenState extends State<TelemetryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TelemetryProvider>().loadTelemetryData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Telemetry Streaming'),
      ),
      body: Consumer<TelemetryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.logs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!, style: const TextStyle(color: AppColors.danger)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.loadTelemetryData,
                    child: const Text('Refresh Nodes'),
                  )
                ],
              ),
            );
          }

          if (provider.logs.isEmpty) {
            return const Center(child: Text('No active telemetry log history returned.'));
          }

          final latest = provider.logs.first;

          return RefreshIndicator(
            onRefresh: provider.loadTelemetryData,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildRealtimeStatusCard(latest),
                const SizedBox(height: 20),
                const Text('Historical Node Logs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.logs.length,
                  itemBuilder: (context, index) {
                    final log = provider.logs[index];
                    return Card(
                      // 🟢 FIXED: Changed from invalid 'EdgeInsets.bottom(8.0)' to 'EdgeInsets.only(bottom: 8.0)'
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: const Icon(Icons.analytics, color: AppColors.primary),
                        title: Text('Cumulative Flow: ${Formatters.formatWaterVolume(log.cumulativeVolume)}'),
                        subtitle: Text('Flow Rate: ${log.currentFlowRate.toStringAsFixed(3)} m³/h\nLogged: ${Formatters.formatDate(log.capturedAt)}'),
                        trailing: Text('${log.signalStrength} dBm', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRealtimeStatusCard(latest) {
    return Card(
      color: AppColors.primaryDark,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('METER NODE: ${latest.meterId}', style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Current Totalizer Index', style: TextStyle(color: Colors.white, fontSize: 16)),
            Text(Formatters.formatWaterVolume(latest.cumulativeVolume), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white30, height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricTile(Icons.speed, 'Flow Rate', '${latest.currentFlowRate} m³/h'),
                _buildMetricTile(Icons.battery_charging_full, 'Battery', '${latest.batteryVoltage} V'),
                _buildMetricTile(Icons.wifi, 'Signal', '${latest.signalStrength} dBm'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}