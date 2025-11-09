import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'common/app_button.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.currentPage,
    this.totalPages = 4,
    required this.onNext,
    required this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          SvgPicture.asset(imagePath, height: 250),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 3),
          AppButton(
            text: 'Get started',
            onPressed: onNext,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: onSkip, child: const Text('Skip')),
              Row(
                children: List.generate(totalPages, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentPage == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentPage == index ? Colors.blue : Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              TextButton(onPressed: onNext, child: const Text('Next')),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
