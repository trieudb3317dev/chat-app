import 'dart:async';

import 'package:chat_app/common/app_button.dart';
import 'package:chat_app/common/app_text_field.dart';
import 'package:chat_app/common/verification_code_input.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';

// Enum to define the authentication action
enum AuthAction { login, register }

class VerifyOtpScreen extends StatefulWidget {
  final Map<String, dynamic> otpPayload;
  final AuthAction authAction;

  const VerifyOtpScreen({
    Key? key,
    required this.otpPayload,
    this.authAction = AuthAction.register, // Default to register for backward compatibility
  }) : super(key: key);

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  Duration _timeRemaining = Duration.zero;

  late final String _phoneNumber;
  late final String _initialOtp;

  @override
  void initState() {
    super.initState();

    // Safely extract data from payload
    _initialOtp = widget.otpPayload['otp']?.toString() ?? '';
    final exp = widget.otpPayload['exp'];
    final expirationTime = (exp is num) ? exp.toInt() : 0;
    _phoneNumber = widget.otpPayload['phone_number']?.toString() ?? 'Unknown';

    // We no longer set the controller here, we will pass the initial value to the widget
    // _otpController.text = _initialOtp;

    _startTimer(expirationTime);
  }

  void _startTimer(int expirationTime) {
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(expirationTime * 1000);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (now.isAfter(expiresAt)) {
        setState(() {
          _timeRemaining = Duration.zero;
        });
        _timer?.cancel();
      } else {
        setState(() {
          _timeRemaining = expiresAt.difference(now);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _usernameController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _performAuthAction() async {
    if (widget.authAction == AuthAction.register && _usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username')),
      );
      return;
    }
    
    // Use the controller text, which is updated by the VerificationCodeInput widget
    final currentOtp = _otpController.text;

    if (currentOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    if (_timeRemaining == Duration.zero) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP has expired. Please request a new one.')),
      );
      return;
    }

    try {
      if (widget.authAction == AuthAction.login) {
        await _authService.login(_phoneNumber, currentOtp);
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      } else {
        await _authService.register(_usernameController.text, currentOtp, _phoneNumber);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful! Please log in.')),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final isRegistering = widget.authAction == AuthAction.register;

    return Scaffold(
      appBar: AppBar(
        title: Text(isRegistering ? 'Create Account' : 'Verify Login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isRegistering ? 'Almost there!' : 'Welcome Back!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'An OTP was sent to $_phoneNumber. Enter it below to proceed.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            if (isRegistering)
              AppTextField(
                controller: _usernameController,
                hintText: 'Enter your username',
              ),
            if (isRegistering) const SizedBox(height: 24),
            // ** THE FIX IS HERE: Pass the initial OTP value **
            VerificationCodeInput(
              initialValue: _initialOtp,
              controller: _otpController, // The controller is still useful for reading the final value
              onCompleted: (otp) {
                 // The controller is already updated, but you can add extra logic here if needed
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('OTP expires in: '),
                Text(
                  _formatDuration(_timeRemaining),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _timeRemaining.inSeconds > 30 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            AppButton(
              text: isRegistering ? 'Verify & Register' : 'Verify & Login',
              onPressed: _performAuthAction,
            ),
          ],
        ),
      ),
    );
  }
}
