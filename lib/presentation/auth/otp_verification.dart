import 'package:flutter/material.dart';
import '../../core/constants/api_constants.dart';
import 'auth_config.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  void _submitVerify() async {
    if (_otpController.text.trim().length < 4) return;
    setState(() => _isLoading = true);

    try {
      await apiClient.post(ApiConstants.verifyOtp, {
        'phone_number': widget.phoneNumber,
        'otp_code': _otpController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account Verified! Please Log In.'))
        );
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } catch (failure) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Phone')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter OTP token code generated for ${widget.phoneNumber}', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: 'OTP Code'),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _submitVerify, child: const Text('Verify Account')),
          ],
        ),
      ),
    );
  }
}