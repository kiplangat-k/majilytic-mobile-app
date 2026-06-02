// lib/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // 1. Validate form fields before hitting Spring Boot APIs
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // 2. Fires the request to your Spring Boot backend via the auth provider pipeline
      final success = await authProvider.loginUser(
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      // 3. Handle backend response status
      if (success && mounted) {
        // SUCCESS: Show a beautiful green floating pop-up
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Login Successful! Welcome back.'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // FIX: Safely read the role string and enforce upper-case matching
        final userRole = authProvider.userRole?.toUpperCase() ?? 'TENANT';

        // NAVIGATE: Routes accurately based on database authority level or generalized dashboard
        if (userRole == 'ADMIN') {
          Navigator.pushReplacementNamed(context, '/admin_dashboard');
        } else if (userRole == 'LANDLORD') {
          Navigator.pushReplacementNamed(context, '/landlord_dashboard');
        } else if (userRole == 'TENANT') {
          Navigator.pushReplacementNamed(context, '/tenant_dashboard');
        } else {
          // THE FIX: Routes directly to your primary unified dashboard screen path
          Navigator.pushReplacementNamed(context, '/dashboard');
        }

      } else if (mounted) {
        final dynamicError = authProvider.errorMessage;
        _showError(dynamicError ?? 'Invalid phone number or password credentials.');
      }
    } catch (e) {
      if (mounted) {
        _showError('Could not connect to the server. Please check your connection.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper method configured to always render a red error snackbar cleanly
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Subtle light background contrast

      // --- 🔷 TOP BLUE APPLICATION HEADER BAR ---
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B77ED), // Deep navy primary brand blue
        elevation: 2,
        centerTitle: true,
        automaticallyImplyLeading: false, // Ensures no back buttons automatically render here
        title: const Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.water_drop, size: 80, color: Color(0xFF2B77ED)),
                  const SizedBox(height: 16),
                  const Text(
                    'Majilytic App',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Text(
                    'Sign in to manage your smart water utilities',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Phone input text field
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone, color: Color(0xFF2B77ED)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2B77ED), width: 2.0),
                      ),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Please enter your phone number' : null,
                  ),
                  const SizedBox(height: 16),

                  // Password input text field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock, color: Color(0xFF2B77ED)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.blue),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2B77ED), width: 2.0),
                      ),
                    ),
                    validator: (val) => val == null || val.length < 4 ? 'Password must be valid' : null,
                  ),
                  const SizedBox(height: 24),

                  // Interactive Submit Button hooked to Spring Boot trigger
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF2B77ED),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                        : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),

                  // Registration Link
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    style: TextButton.styleFrom(foregroundColor: const Color(0xFF2B77ED)),
                    child: const Text("Don't have an account? Register here"),
                  ),

                  // Forgot Password link positioned below the register link
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                      style: TextButton.styleFrom(foregroundColor: const Color(
                          0xFF2B77ED)),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}