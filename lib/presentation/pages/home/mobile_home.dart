import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kyc_test/core/services/network_service.dart';
import 'package:kyc_test/main.dart';
import 'package:sized_context/sized_context.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: context.widthPx * -0.56,
            bottom: context.heightPx * -0,
            child: SizedBox(
              height: context.heightPct(0.85),
              width: context.widthPct(1.3),
              child: SvgPicture.asset(
                'assets/images/obsidian_logo.svg',
                fit: BoxFit.contain,
              ),
            ),
          ).animate().fadeIn(),

          // ! idk why i kept this :P
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: FractionalTranslation(
          //     translation: const Offset(0.45, 0),
          //     child: SizedBox(
          //       height: context.heightPct(2.1),
          //       width: context.widthPct(2.1),
          //       child: SvgPicture.asset(
          //         'assets/images/obsidian_logo.svg',
          //         fit: BoxFit.contain,
          //       ),
          //     ),
          //   ),
          // ).animate().fadeIn(),
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
