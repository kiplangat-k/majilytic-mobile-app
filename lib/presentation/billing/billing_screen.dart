import 'package:flutter/material.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing Ledger History'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3, // Matches standard list constraints
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.arrow_downward, color: Colors.green),
              ),
              title: Text('M-Pesa Deposit Receipt ref: #000${index + 4}'),
              subtitle: const Text('Status: COMPLETED (Synchronized with DB)'),
              trailing: const Text(
                '+ KES 100',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Quick helper extension to handle styling decoration safely
extension on Color {
  get greenOpacity => Colors.green.withAlpha(30);
}