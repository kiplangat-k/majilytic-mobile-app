import 'package:flutter/material.dart';
import '../../core/constants/api_constants.dart';
import '../auth/auth_config.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isProcessing = false;
  late double _currentBalance;

  @override
  void initState() {
    super.initState();
    // Safe fallback conversion mechanism parsing wallet_balance parameters out of configuration mappings
    _currentBalance = double.parse((currentUserSession?['wallet_balance'] ?? 0.0).toString());
  }

  void _triggerMpesaDeposit() async {
    setState(() => _isProcessing = true);
    try {
      // Connects with your Spring Boot payment logic setup (triggers STK push request)
      final response = await apiClient.post(ApiConstants.walletDeposit, {
        'phone_number': currentUserSession?['phone_number'],
        'amount': 100.00, // Example preset baseline transaction input metric
      });

      // Simulates real-time application database sync polling updates locally
      setState(() {
        _currentBalance += 100.00;
        if (currentUserSession != null) {
          currentUserSession!['wallet_balance'] = _currentBalance;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'STK push initialized successfully!')),
        );
      }
    } catch (failure) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.toString())),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Operations'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Available Active Balance',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'KES ${_currentBalance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 48),

              _isProcessing
                  ? const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Check your phone for the M-Pesa PIN prompt...'),
                ],
              )
                  : ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _triggerMpesaDeposit,
                icon: const Icon(Icons.add_card),
                label: const Text('Simulate M-Pesa KES 100 Deposit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}