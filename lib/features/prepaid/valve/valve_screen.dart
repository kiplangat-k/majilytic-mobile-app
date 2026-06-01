// lib/features/prepaid/valve/valve_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'valve_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/constants/app_colors.dart';

class ValveScreen extends StatefulWidget {
  const ValveScreen({super.key});

  @override
  State<ValveScreen> createState() => _ValveScreenState();
}

class _ValveScreenState extends State<ValveScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ValveProvider>().loadValveState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final valveProvider = context.watch<ValveProvider>();
    final state = valveProvider.valveState;
    final bool isOpened = state?.currentStatus == 'OPEN';

    return Scaffold(
      appBar: AppBar(title: const Text('Meter Hardware Control')),
      body: valveProvider.isLoading && state == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: valveProvider.loadValveState,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(Icons.router, size: 48, color: AppColors.textSecondary),
                      const SizedBox(height: 8),
                      Text('DEVICE ID: ${state?.meterId ?? 'FETCHING...'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Topic: ${state?.telemetryTopic ?? 'N/A'}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Helpers.getValveStatusColor(state?.currentStatus ?? '').withOpacity(0.12),
                  border: Border.all(
                    color: Helpers.getValveStatusColor(state?.currentStatus ?? ''),
                    width: 4,
                  ),
                ),
                child: Icon(
                  isOpened ? Icons.water_drop : Icons.water_drop_outlined,
                  size: 80,
                  color: Helpers.getValveStatusColor(state?.currentStatus ?? ''),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'VALVE STATE: ${state?.currentStatus ?? 'UNKNOWN'}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Helpers.getValveStatusColor(state?.currentStatus ?? ''),
                  ),
                ),
              ),
              Center(
                child: Text(
                  state != null ? 'Last Switch: ${Formatters.formatDate(state.statusLastChanged)}' : '',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOpened ? AppColors.danger : AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: valveProvider.isLoading
                    ? null
                    : () async {
                  final ok = await valveProvider.toggleValveActuation(!isOpened);
                  if (mounted) {
                    Helpers.showStatusSnackBar(
                      context,
                      message: ok ? 'Actuation command acknowledged by node' : 'Command dropped by broker telemetry connection failure',
                      isError: !ok,
                    );
                  }
                },
                child: valveProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isOpened ? 'SHUT DOWN FLOW VALVE' : 'ACTIVATE WATER FLOW VALVE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}