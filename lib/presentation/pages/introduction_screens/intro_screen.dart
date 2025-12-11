import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:kyc_test/presentation/pages/auth/login.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [Color(0xFF042A2B), Color(0xFF021416)],
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
        height: 1.5,
      ),
      contentMargin: const EdgeInsets.symmetric(horizontal: 25),
      imagePadding: const EdgeInsets.only(bottom: 10),
      pageColor: Colors.transparent,
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: Padding(
            // 👇 pushes ALL the onboarding content a bit downward
            padding: const EdgeInsets.only(top: 150),
            child: IntroductionScreen(
              globalBackgroundColor: Colors.transparent,
              hideBottomOnKeyboard: true,

              pages: [
                // 1) Welcome
                PageViewModel(
                  title: "Welcome to StepUp",
                  body:
                      "The hub where founders, investors and mentors move faster together.",
                  image: const _OnboardingSvg(
                    assetPath: 'assets/realWelcome.svg',
                  ),
                  decoration: pageDecoration,
                ),

                // 2) For Startups
                PageViewModel(

                  title: "Boost Your Startup",
                  body:
                      "Show your startup, get feedback, and prepare for real investment.",
                  image: const _OnboardingSvg(assetPath: 'assets/boost.svg',),
                  decoration: pageDecoration,
                ),

                // 3) For Investors (KYC + banking)
                PageViewModel(
                  title: "Invest With Confidence",
                  body:
                      "Verified investors only, backed by KYC and bank balance checks.",
                  image: const _OnboardingSvg(assetPath: 'assets/invest.svg'),
                  decoration: pageDecoration,
                ),

                // 4) For Mentors
                PageViewModel(
                  title: "Mentor With Impact",
                  body:
                      "Share your experience and help founders avoid the mistakes you’ve seen.",
                  image: const _OnboardingSvg(assetPath: 'assets/mentor.svg'),
                  decoration: pageDecoration,
                ),

                // 5) Security & KYC
                PageViewModel(
                  title: "Trusted & Secure",
                  body:
                      "StepUp keeps your identity and data safe while you focus on growth.",
                  image: const _OnboardingSvg(assetPath: 'assets/secure.svg'),
                  decoration: pageDecoration,
                ),
              ],

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
      ),
    );
  }
}

/// SVG helper widget for onboarding illustrations (no circle)
class _OnboardingSvg extends StatelessWidget {
  final String assetPath;

  const _OnboardingSvg({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 500,
        width: 500,
        child: SvgPicture.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }
}
