import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// 🟢 FIXED: Import your existing session engine to access user state management
import '../providers/session_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🟢 FIXED: Safely query the active session properties directly out of your Provider pipeline
    final sessionProvider = Provider.of<SessionProvider>(context);

    // Safely pull information from the session provider.
    final user = sessionProvider.user;

    final userId = user?.id ?? 'N/A';
    final fullName = user?.fullName ?? 'N/A';
    final phoneNumber = user?.phoneNumber ?? 'N/A';
    // 🟢 FIXED: Changed from user?.role to user?.systemRole to match your UserModel definition
    final roleAttribute = user?.systemRole ?? 'CUSTOMER';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileItem('Account ID Reference', userId.toString()),
            const Divider(),
            _buildProfileItem('Full Legal Name', fullName),
            const Divider(),
            _buildProfileItem('Linked Phone String', phoneNumber),
            const Divider(),
            _buildProfileItem('Role Level Attribute', roleAttribute, isBadge: true),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50), // Spans across full width beautifully
              ),
              onPressed: () async {
                // 🟢 FIXED: If you implement Option 2 below, this works perfectly.
                // If you don't want to change SessionProvider, change this line to a custom logout call if you have one.
                await sessionProvider.clearSession();

                // Routes the unauthenticated container back to your initial login screen
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                }
              },
              child: const Text('Sign Out / Terminate Frontend Session'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value, {bool isBadge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          isBadge
              ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          )
              : Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}