import 'package:flutter/material.dart';

class PostpaidWaterScreen extends StatelessWidget {
  const PostpaidWaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Ultra clean background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context), // Seamless transition back to dashboard
        ),
        title: const Text(
          'Postpaid Water',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
        children: [
          _buildMenuRowItem(
            icon: Icons.receipt_long_outlined, // Icon representing "Water Bills"
            title: 'Water Bills',
            onTap: () {
              // Add route or dialog handling for checking/paying statements
              Navigator.pushNamed(context, '/billing');
            },
          ),
          const Divider(height: 1, thickness: 0.5, indent: 56, color: Color(0xFFE2E8F0)),
          _buildMenuRowItem(
            icon: Icons.tune_rounded, // Sliders/settings icon representing "Meter Status"
            title: 'Meter Status',
            onTap: () {
              // Add route handling for live meter connectivity overview
            },
          ),
        ],
      ),
    );
  }

  // Pure functional item renderer completely matches image specifications
  Widget _buildMenuRowItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF334155), size: 26),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF475569),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}