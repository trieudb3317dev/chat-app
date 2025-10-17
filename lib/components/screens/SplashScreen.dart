import 'package:chat_app/configs/color.config.dart';
import 'package:chat_app/configs/image.config.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.mediaSize,
    required this.onboardingImageString,
    required this.content,
  });

  final Size mediaSize;
  final String onboardingImageString;
  final String content;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              width: widget.mediaSize.width,
              height: widget.mediaSize.height,
              child: Image.asset(
                widget.onboardingImageString,
                width: widget.mediaSize.width * 0.2,
                height: widget.mediaSize.height * 0.4,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.content,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: ColorConfig.lightMode.neutral500Text,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: widget.mediaSize.width,
              height: 60,
              decoration: BoxDecoration(
                color: ColorConfig.blue.blue500,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Center(
                child: Text(
                  'Bat dau ngay',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: ColorConfig.lightMode.neutral100Text,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Quay lai',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorConfig.blue.blue600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Tiep theo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorConfig.blue.blue600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashItem {
  final String onboardingImageString;
  final String content;
  final int index;

  SplashItem({
    required this.onboardingImageString,
    required this.content,
    required this.index,
  });
}

