import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kyc_test/presentation/pages/auth/login.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [
        Color(0xFF042A2B),
        Color(0xFF021416),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final pageDecoration = PageDecoration(
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
      bodyTextStyle: TextStyle(
        color: Colors.white.withOpacity(0.75),
        fontSize: 13,
      ),
      contentMargin: const EdgeInsets.symmetric(horizontal: 24),
      imagePadding: const EdgeInsets.only(top: 40, bottom: 24),
      pageColor: Colors.transparent, // important for gradient to show
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: IntroductionScreen(
            globalBackgroundColor: Colors.transparent,
            pages: [
              PageViewModel(
                title: "Welcome",
                body: "This is the first introduction screen.",
                image: const _OnboardingIcon(
                  icon: Icons.home,
                  color: Color(0xFFB08B4F),
                ),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Easy to Use",
                body: "Quick onboarding for your users.",
                image: const _OnboardingIcon(
                  icon: Icons.touch_app,
                  color: Colors.greenAccent,
                ),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Get Started",
                body: "Let's begin using the app!",
                image: const _OnboardingIcon(
                  icon: Icons.check_circle_outline,
                  color: Colors.orangeAccent,
                ),
                decoration: pageDecoration,
              ),
            ],

            // Navigation buttons styled like your auth UI
            showSkipButton: true,
            skip: Text(
              "Skip",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
            next: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 18,
            ),
            done: const Text(
              "Get started",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFFB08B4F),
                fontSize: 13,
              ),
            ),

            onDone: () {
              Get.offAll(() => const LoginScreen());
            },

            dotsDecorator: DotsDecorator(
              size: const Size(6, 6),
              color: Colors.white.withOpacity(0.35),
              activeColor: const Color(0xFFB08B4F),
              activeSize: const Size(18, 6),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }
}

/// Little helper widget so icons look more "designed"
class _OnboardingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _OnboardingIcon({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.4),
          ),
        ),
        child: Icon(
          icon,
          size: 60,
          color: color,
        ),
      ),
    );
  }
}
