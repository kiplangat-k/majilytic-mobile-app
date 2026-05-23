import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/validator.dart';
import 'auth_config.dart';
import 'login_screen.dart';
import 'otp_verification.dart';
// Ensure your Login screen file is imported here if you use pushReplacement
// import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _otherNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // New Controllers
  final _meterNumberController = TextEditingController();
  final _roleController = TextEditingController();

  final _passwordController = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = false;

  // List of available roles for the dropdown selection
  final List<String> _roles = ['TENANT', 'LANDLORD', 'ADMIN'];
  String? _selectedRole = 'TENANT'; // Sets TENANT as the default starting option

  @override
  void initState() {
    super.initState();
    // Sync the initial dropdown choice with your existing controller text logic
    _roleController.text = _selectedRole!;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _otherNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _meterNumberController.dispose();
    _roleController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final phone = _phoneController.text.trim();
    final fullName = '${_firstNameController.text.trim()} ${_secondNameController.text.trim()} ${_otherNameController.text.trim()}'.trim();

    try {
      // Keys matching your backend requirements
      final registrationPayload = {
        'fullName': fullName,
        'phoneNumber': phone,
        'email': _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        'account_number': _meterNumberController.text.trim().isEmpty ? null : _meterNumberController.text.trim(),
        // 🟢 UPDATED: Defaulting to 'TENANT' if empty, keeping it clean of 'CUSTOMER'
        'role': _roleController.text.trim().isEmpty ? 'TENANT' : _roleController.text.trim().toUpperCase(),
        'password': _passwordController.text.trim(),
      };

      await apiClient.post(
        ApiConstants.register,
        registrationPayload,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Successful! Redirecting to login...'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // 🟢 NAVIGATION CONTROL: Options to route to the login screen cleanly

        // Option A: If your login screen opened this screen via Navigator.push(),
        // popping returns them straight back to that active Login page.
        Navigator.of(context).pop();

        // Option B: If you want to explicitly kill this screen and route directly to your LoginScreen class:
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => const LoginScreen()),
        // );
      }
    } catch (failure) {
      print("--- MAJILYTIC UTILITIES LOG TRACE ---");
      print("System failure object profile type: ${failure.runtimeType}");
      print("Raw registration error details: $failure");

      String visibleMessage = "Registration failed. Please check backend configuration.";

      try {
        visibleMessage = (failure as dynamic).message ?? failure.toString();
      } catch (_) {
        visibleMessage = failure.toString();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(visibleMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Register Account', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xFF0D47A1).withOpacity(0.1), Colors.white],
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.water_drop, size: 40, color: Colors.blue),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Majilytic Systems',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your Water, Simplified.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your name' : null,
                      decoration: _buildInputDecoration('Full Name'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      decoration: _buildInputDecoration('Phone No'),
                      keyboardType: TextInputType.phone,
                      validator: Validator.validatePhone,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: _buildInputDecoration('Email Address'),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validator.validateEmail,
                    ),
                    const SizedBox(height: 20),

                    // Smart Meter Number Text Field
                    TextFormField(
                      controller: _meterNumberController,
                      decoration: _buildInputDecoration('Account_number'),
                      keyboardType: TextInputType.text,
                      validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your Smart Meter Number' : null,
                    ),
                    const SizedBox(height: 20),

                    // Dropdown Form Field for Role Choice
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: _buildInputDecoration('Role'),
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0D47A1)),
                      items: _roles.map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role, style: const TextStyle(color: Colors.black87)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRole = newValue;
                          _roleController.text = newValue ?? '';
                        });
                      },
                      validator: (value) => value == null || value.isEmpty ? 'Please select a role' : null,
                    ),
                    const SizedBox(height: 20),

                    // Password Text Field
                    TextFormField(
                      controller: _passwordController,
                      decoration: _buildInputDecoration('Password'),
                      obscureText: true,
                      validator: Validator.validatePassword,
                    ),
                    const SizedBox(height: 32),

                    _isLoading
                        ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D47A1)))
                        : ElevatedButton(
                      onPressed: _submitRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // 🟢 Clears the registration screen and slides the Login page into place
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text('Already have an account..? Login', style: TextStyle(color: Color(0xFF0D47A1))),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}