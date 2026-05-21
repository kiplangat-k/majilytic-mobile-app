import 'package:flutter/material.dart';
import '../auth/auth_config.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reads directly out of the shared global memory reference context
    final userId = currentUserSession?['id'] ?? 'N/A';
    final fullName = currentUserSession?['full_name'] ?? 'N/A';
    final phoneNumber = currentUserSession?['phone_number'] ?? 'N/A';
    final roleAttribute = currentUserSession?['role'] ?? 'CUSTOMER';

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
              ),
              onPressed: () {
                currentUserSession = null; // Clear tracking cache memory data references
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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