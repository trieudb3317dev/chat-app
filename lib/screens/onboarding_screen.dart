import 'package:chat_app/onboarding_page.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/configs/image.config.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': ImageConfig.onboarding1,
      'title': 'Group Chatting',
      'description': 'Connect with multiple members in group chats.',
    },
    {
      'image': ImageConfig.onboarding2,
      'title': 'Video And Voice Calls',
      'description': 'Instantly connect via video and voice calls.',
    },
    {
      'image': ImageConfig.onboarding3,
      'title': 'Message Encryption',
      'description': 'Create privacy with encrypted messages.',
    },
    {
      'image': ImageConfig.onboarding4,
      'title': 'Cross-Platform Compatibility',
      'description': 'Access chats on any device, seamlessly.',
    },
  ];

  void _onNext() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _onSkip() {
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _onboardingData.length,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return OnboardingPage(
            imagePath: _onboardingData[index]['image']!,
            title: _onboardingData[index]['title']!,
            description: _onboardingData[index]['description']!,
            currentPage: _currentPage,
            totalPages: _onboardingData.length,
            onNext: _onNext,
            onSkip: _onSkip,
          );
        },
      ),
    );
  }
}
