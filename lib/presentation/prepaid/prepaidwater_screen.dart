import 'package:flutter/material.dart';

class PrepaidWaterScreen extends StatelessWidget {
  const PrepaidWaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Ultra clean light background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context), // Pops back seamlessly to main Dashboard
        ),
        title: const Text(
          'Prepaid Water',
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
            icon: Icons.shopping_cart_outlined,
            title: 'Buy Water Token',
            onTap: () {
              // Add your token buying dialog trigger or route link here
            },
          ),
          const Divider(height: 1, thickness: 0.5, indent: 56, color: Color(0xFFE2E8F0)),
          _buildMenuRowItem(
            icon: Icons.water_outlined,
            title: 'Water Usage',
            onTap: () {
              Navigator.pushNamed(context, '/billing');
            },
          ),
          const Divider(height: 1, thickness: 0.5, indent: 56, color: Color(0xFFE2E8F0)),
          _buildMenuRowItem(
            icon: Icons.bar_chart_rounded,
            title: 'Analytics',
            onTap: () {
              Navigator.pushNamed(context, '/analytics');
            },
          ),
        ],
      ),
    );
  }

  // Exact UI Row Builder matching image_8b95f2.png styling rules
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