import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kyc_test/core/services/network_service.dart';
import 'package:kyc_test/main.dart';
import 'package:sized_context/sized_context.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MentorDashBoard extends StatelessWidget {
  const MentorDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: context.widthPx * -0.56,
            bottom: 0,
            child: Opacity(
              opacity: 0.2, // 👈 your desired opacity
              child: SizedBox(
                height: context.heightPct(0.85),
                width: context.widthPct(1.2),
                child: SvgPicture.asset(
                  'assets/bss_man.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ).animate().fadeIn(),

          Center(
            child: Obx(
              () => Skeletonizer(
                enabled: isOffline.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(app.isDarkMode ? "DarkMode" : "lightMode"),
                    SizedBox(height: 20.h),
                    Obx(() {
                      return Text(
                        isOffline.value ? "Offline" : "Online",
                        style: Theme.of(context).textTheme.titleMedium,
                      );
                    }),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
