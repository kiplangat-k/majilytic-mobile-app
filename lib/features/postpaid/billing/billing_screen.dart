// lib/features/postpaid/billing/billing_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'billing_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/constants/app_colors.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BillingProvider>().loadBillingData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing & Invoices'),
      ),
      body: Consumer<BillingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.statements.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.statements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!, style: const TextStyle(color: AppColors.danger)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.loadBillingData,
                    child: const Text('Retry Connection'),
                  )
                ],
              ),
            );
          }

          if (provider.statements.isEmpty) {
            return const Center(child: Text('No historical invoices found.'));
          }

          return RefreshIndicator(
            onRefresh: provider.loadBillingData,
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: provider.statements.length,
              itemBuilder: (context, index) {
                final bill = provider.statements[index];
                return Card(
                  // 🟢 FIXED: Changed from invalid 'EdgeInsets.bottom(12.0)' to 'EdgeInsets.only(bottom: 12.0)'
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Invoice #${bill.billId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        _buildStatusBadge(bill),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text('Volume Consumed: ${Formatters.formatWaterVolume(bill.consumptionVolume)}'),
                        Text('Billing Date: ${Formatters.formatDate(bill.billingDate)}'),
                        Text('Due Date: ${Formatters.formatDate(bill.dueDate)}',
                            style: TextStyle(color: bill.isOverdue ? AppColors.danger : null)),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Formatters.formatCurrency(bill.amountDue),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                            if (bill.paymentStatus == 'UNPAID')
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(minimumSize: const Size(100, 36)),
                                onPressed: () async {
                                  final ok = await provider.settleBill(bill.billId, bill.amountDue);
                                  if (mounted) {
                                    Helpers.showStatusSnackBar(
                                      context,
                                      message: ok ? 'Payment processing initiated' : 'Settlement request failed',
                                      isError: !ok,
                                    );
                                  }
                                },
                                child: const Text('Pay Now'),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(bill) {
    final bool paid = bill.paymentStatus == 'PAID';
    final Color color = paid ? AppColors.success : (bill.isOverdue ? AppColors.danger : AppColors.warning);
    return Container(
      // 🟢 FIXED: Changed unknown parameter 'py: 4' to 'vertical: 4'
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        bill.isOverdue ? 'OVERDUE' : bill.paymentStatus,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}