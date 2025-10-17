import 'package:chat_app/components/common/phone_number_input.dart';
import 'package:chat_app/components/common/verification_code_input.dart';
import 'package:chat_app/components/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showOtpInput = false;
  bool _rememberMe = false;
  final _phoneController = TextEditingController();

  void _submitPhoneNumber() {
    if (_phoneController.text.isNotEmpty) {
      setState(() {
        _showOtpInput = true;
      });
    }
  }

  void _verifyOtp(String otp) {
    // Here you would typically verify the OTP with your backend
    print("Entered OTP: $otp");
    // If successful, navigate to home
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Navigate to Register Screen
            },
            child: const Text('Register', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
            child: Text(
              _showOtpInput ? 'Enter OTP Code' : 'Enter your mobile phone',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
           if (_showOtpInput)
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
              child: Text(
                'Sent to: (+44) ${_phoneController.text}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: _showOtpInput ? _buildOtpInput() : _buildPhoneInput(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'You will get a code via sms',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        PhoneNumberInput(
          controller: _phoneController,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value!;
                    });
                  },
                ),
                const Text('Remember me'),
              ],
            ),
            FloatingActionButton(
              onPressed: _submitPhoneNumber,
              child: const Icon(Icons.arrow_forward),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Column(
      children: [
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
            SizedBox(width: 4),
            Text('00:46'), // This should be a stateful timer
            SizedBox(width: 16),
            Text('Resend Code', style: TextStyle(color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 16),
        VerificationCodeInput(
          onCompleted: _verifyOtp,
        ),
        const SizedBox(height: 32),
         Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                // This is handled by onCompleted in VerificationCodeInput
              },
              child: const Icon(Icons.arrow_forward),
            )
          ],
        ),
      ],
    );
  }
}
