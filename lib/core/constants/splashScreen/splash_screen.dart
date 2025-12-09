// lib/splash/obsidian_splash_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kyc_test/core/constants/assets/assets.dart';
import 'package:kyc_test/presentation/layout/layout_page.dart';

class ObsidianSplashPage extends StatefulWidget {
  const ObsidianSplashPage({super.key});

  @override
  State<ObsidianSplashPage> createState() => _ObsidianSplashPageState();
}

class _ObsidianSplashPageState extends State<ObsidianSplashPage> {
  @override
  void initState() {
    super.initState();
    _startBootstrap();
  }

  Future<void> _startBootstrap() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    Get.offAll(() => const LayoutPage());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.colorScheme.surface;
    final logoPath = isDark ? obsidianSvgLogoDark : obsidianSvgLogoLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            SvgPicture.asset(
              logoPath,
              width: 150.w,
              height: 150.w,
              fit: BoxFit.contain,
            ).animate().fadeIn(duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
