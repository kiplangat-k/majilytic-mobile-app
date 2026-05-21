import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Ensure this matches the exact package path configuration of your project
import '../auth/auth_config.dart';
import '../postpaid/postpaidwater_screen.dart';
import '../prepaid/prepaidwater_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;

  // Track the active UI toggle tab independently of the user's backend profile fallback
  String _activeTab = "PREPAID"; // "PREPAID" or "POSTPAID"

  // Data variables fetched from your Spring Boot backend
  String _meterType = "PREPAID";
  double _balance = 0.0;
  String _meterNumber = "MAJI-88301";

  @override
  void initState() {
    super.initState();
    _fetchMeterDetails();
  }

  // 🌟 CONSUMING SPRING BOOT: Fetch current user's water profile
  Future<void> _fetchMeterDetails() async {
    try {
      final response = await apiClient.get('/api/v1/meters/my-profile');

      if (response != null && response['success'] == true) {
        final data = response['data'];
        setState(() {
          _meterType = data['meter_type']; // "PREPAID" or "POSTPAID"
          _balance = double.parse(data['balance'].toString());
          _meterNumber = data['meter_number'];

          // Match the default active view tab to the user's real meter profile configuration
          _activeTab = _meterType;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching meter details: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = currentUserSession?['user']?['full_name'] ??
        currentUserSession?['full_name'] ??
        'Valued Customer';

    // INDEX 0: Primary Main Dashboard matching your reference layout precisely
    final Widget dashboardView = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
      onRefresh: _fetchMeterDetails,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        children: [
          // Welcome Section
          Text('Welcome back,', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // 1. 🌟 SIDE-BY-SIDE PREPAID & POSTPAID TOGGLE SELECTORS
          Row(
            children: [
              // Integrated Prepaid Navigation Trigger
              Expanded(
                child: _buildSelectorButton(
                  label: 'Prepaid',
                  icon: Icons.opacity,
                  isActive: _activeTab == "PREPAID",
                  activeColor: const Color(0xFF00A6FF),
                  onTap: () {
                    setState(() => _activeTab = "PREPAID");
                    // 🌟 Navigate directly to the sub-menu layout from your image
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrepaidWaterScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Find the Postpaid button inside the main Row of DashboardScreen
              Expanded(
                child: _buildSelectorButton(
                  label: 'Postpaid',
                  icon: Icons.receipt,
                  isActive: _activeTab == "POSTPAID",
                  activeColor: const Color(0xFFD946EF),
                  onTap: () {
                    setState(() => _activeTab = "POSTPAID");
                    // 🌟 Navigate directly to your new Postpaid submenu page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PostpaidWaterScreen()),
                    );
                  },
                ),
              ),
            ], // 🌟 FIXED: Added missing closing bracket for Row children list
          ), // 🌟 FIXED: Added missing closing paren for Row constructor parameters
          const SizedBox(height: 24),

          // 2. 🌟 QUICK PAY ACCOUNT DETAILS CONTAINER
          const Text(
            'Quick Pay Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF4A5568)),
          ),
          const SizedBox(height: 8),
          _buildQuickPayDetailsCard(),
          const SizedBox(height: 24),

          // 3. 🌟 DYNAMIC "HOW TO USE" INSTRUCTION MATRICES
          const Text(
            'How to Use',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF4A5568)),
          ),
          const SizedBox(height: 12),
          _buildHowToUseCard(),
          const SizedBox(height: 24),

          // 4. 🌟 ORIGINAL UTILITY NAVIGATION LIST TILES
          const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D3E73))),
          const SizedBox(height: 8),
          _buildActionCard(
            icon: Icons.account_balance_wallet_outlined,
            color: Colors.blue,
            title: 'Statement History',
            subtitle: 'View historical transaction logs and usage metrics.',
            onTap: () => Navigator.pushNamed(context, '/billing'),
          ),
          _buildActionCard(
            icon: Icons.analytics_outlined,
            color: Colors.purple,
            title: 'Usage Analytics',
            subtitle: 'Monitor your monthly smart water consumption graphs.',
            onTap: () => Navigator.pushNamed(context, '/analytics'),
          ),
        ],
      ),
    );

    final List<Widget> pages = [
      dashboardView,
      const Center(child: Text('Settings Panel', style: TextStyle(fontSize: 20))),
      const Center(child: Text('Raise a Complaint / Support Ticket', style: TextStyle(fontSize: 20))),
      const Center(child: Text('App Release Updates Ledger', style: TextStyle(fontSize: 20))),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        // 🌟 ADDED BACK ARROW BUTTON HERE
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            // Replaces dashboard route to clean up navigation history stacks gracefully
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
        title: const Text('Majilytic Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.black87),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: const Color(0xFFEADBFC),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87);
            }
            return const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black54);
          }),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_customize_outlined), selectedIcon: Icon(Icons.dashboard_customize), label: 'Dashboard'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
            NavigationDestination(icon: Icon(Icons.chat_bubble_outline_rounded), selectedIcon: Icon(Icons.add_comment), label: 'Complain'),
            NavigationDestination(icon: Icon(Icons.new_releases_outlined), selectedIcon: Icon(Icons.new_releases), label: 'App Updates'),
          ],
        ),
      ),
    );
  }

  // Helper item widget to render button cards
  Widget _buildSelectorButton({
    required String label,
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isActive ? activeColor.withAlpha(60) : Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: isActive ? Colors.white : Colors.grey[600], size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPayDetailsCard() {
    bool isPrepaidView = _activeTab == "PREPAID";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FDF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDEF7EC), width: 1.5),
      ),
      child: Column(
        children: [
          const Text(
            'DETAILS FOR WATER PAYMENT',
            style: TextStyle(color: Color(0xFF0E6245), fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Color(0xFFBCF0DA)),
          ),
          _buildDetailRow('Pay Bill No:', '400200'),
          const SizedBox(height: 12),
          _buildDetailRow('Account No:', _meterNumber),
          const SizedBox(height: 12),
          _buildDetailRow(
            isPrepaidView ? 'Live Units Vol:' : 'Outstanding Invoice:',
            isPrepaidView ? '${_balance.toStringAsFixed(2)} m³' : 'KES ${_balance.toStringAsFixed(2)}',
            valueColor: isPrepaidView ? const Color(0xFF00A6FF) : const Color(0xFFD946EF),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isPrepaidView ? const Color(0xFF00A6FF) : const Color(0xFFD946EF),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: () {
              if (isPrepaidView) {
                _showPrepaidPurchaseDialog();
              } else {
                _processPostpaidBillPayment();
              }
            },
            child: Text(
              isPrepaidView ? 'Initialize Token Purchase' : 'Clear Outstanding Bill Balance',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(color: valueColor ?? Colors.black87, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildHowToUseCard() {
    return Column(
      children: [
        _buildInstructionBox(
          title: 'For Prepaid Water',
          bulletColor: const Color(0xFF00A6FF),
          boxBorderColor: const Color(0xFFE0F2FE),
          steps: [
            "Tap the 'Prepaid' button above.",
            "Verify your customized Meter Number string registration.",
            "Click 'Initialize Token Purchase' to type context load values.",
            "Complete authentication routing via M-Pesa push prompts.",
            "Your access token values will update instantly inside database systems."
          ],
        ),
        const SizedBox(height: 16),
        _buildInstructionBox(
          title: 'For Postpaid Water',
          bulletColor: const Color(0xFFD946EF),
          boxBorderColor: const Color(0xFFFCE7F3),
          steps: [
            "Tap the 'Postpaid' button above.",
            "Review current computed balance details returned via your API client data maps.",
            "Verify the outstanding balance invoices generated directly by your Spring Boot background schedulers.",
            "Click 'Clear Outstanding Bill Balance' to execute payment processing payloads.",
            "Once paid, your account balance profile updates instantly."
          ],
        ),
      ],
    );
  }

  Widget _buildInstructionBox({
    required String title,
    required Color bulletColor,
    required Color boxBorderColor,
    required List<String> steps,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: boxBorderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: bulletColor, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: bulletColor, fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((entry) {
            int idx = entry.key + 1;
            String text = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$idx. ', style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.bold)),
                  Expanded(child: Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionCard({required IconData icon, required Color color, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.withAlpha(20))),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: CircleAvatar(backgroundColor: color.withAlpha(30), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, height: 1.3)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  // --- PREPAID: POST ACTION TO BUY TOKENS ---
  void _showPrepaidPurchaseDialog() {
    final amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Top Up Units', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter purchase amount in KES',
            prefixText: 'KES ',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A6FF), foregroundColor: Colors.white),
            onPressed: () async {
              if (amountController.text.trim().isEmpty) return;
              Navigator.pop(context);

              setState(() => _isLoading = true);
              try {
                final response = await apiClient.post('/api/v1/billing/buy-tokens', {
                  'amount': double.parse(amountController.text.trim())
                });

                if (response != null && response['success'] == true) {
                  _fetchMeterDetails();
                }
              } catch (e) {
                debugPrint("Token purchasing connection failed: $e");
                setState(() => _isLoading = false);
              }
            },
            child: const Text('Purchase'),
          )
        ],
      ),
    );
  }

  // --- POSTPAID: POST ACTION TO SETTLE BALANCE ---
  void _processPostpaidBillPayment() async {
    if (_balance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your account statement does not have pending balances.'))
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await apiClient.post('/api/v1/billing/pay-invoice', {
        'amount': _balance
      });

      if (response != null && response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment Successful! Bill settled.'))
        );
        _fetchMeterDetails();
      }
    } catch (e) {
      debugPrint("Postpaid clearing failure: $e");
      setState(() => _isLoading = false);
    }
  }
}