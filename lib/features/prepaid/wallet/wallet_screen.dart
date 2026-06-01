// lib/features/prepaid/wallet/wallet_screen.dart

import 'package:flutter/material.dart';
import 'package:majilytic/features/prepaid/wallet/wallet_model.dart';
import 'package:provider/provider.dart';
import 'wallet_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/constants/app_colors.dart';
//import '../../models/wallet_model.dart'; // 👈 Adjust path to your file location

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().loadWalletData();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleTopUp(WalletProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);
    final phone = _phoneController.text;

    final isTriggered = await provider.topUpWallet(phone: phone, amount: amount);

    if (mounted) {
      Helpers.showStatusSnackBar(
        context,
        message: isTriggered
            ? 'STK Push sent! Enter your M-Pesa PIN to complete.'
            : 'Failed to initiate top-up. Please try again.',
        isError: !isTriggered,
      );
      if (isTriggered) {
        _amountController.clear();
        _phoneController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Prepaid Wallet')),
      body: walletProvider.isLoading && walletProvider.wallet == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: walletProvider.loadWalletData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBalanceCard(walletProvider.wallet),
              const SizedBox(height: 24),
              const Text('Top Up Account via M-Pesa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildTopUpForm(walletProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(WalletModel? wallet) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('AVAILABLE BALANCE', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              wallet != null ? Formatters.formatCurrency(wallet.currentBalance) : 'KES 0.00',
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.white30, height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Acc No: ${wallet?.accountNo ?? 'N/A'}', style: const TextStyle(color: Colors.white)),
                Text(
                  wallet != null ? 'Synced: ${Formatters.formatDate(wallet.lastTopUpDate)}' : '',
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTopUpForm(WalletProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'M-Pesa Phone Number',
                  hintText: 'e.g. 0712345678',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (v) => v == null || v.trim().length < 10 ? 'Enter a valid Safaricom phone number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount (KES)',
                  hintText: 'Minimum 10 KES',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter an amount';
                  final amt = double.tryParse(v);
                  if (amt == null || amt < 10) return 'Minimum top-up amount is KES 10';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: provider.isLoading ? null : () => _handleTopUp(provider),
                child: provider.isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Request Top Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}