import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kyc_test/core/constants/assets/assets.dart';
import 'package:kyc_test/core/constants/themes/colors.dart';
import 'package:kyc_test/main.dart';
import 'package:kyc_test/presentation/pages/search/search_page.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // You can use a percentage of screen width for better responsiveness
      // width: 300.w,
      width: 0.75.sw,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  SvgPicture.asset(obsidianLogo, width: 60.w, height: 60.w),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      "Obsidian",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 22.r),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(height: 1.h),

            // Main items (scrollable)
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 4.h,
                    ),
                    leading: Icon(Icons.delete_outline, size: 22.r),
                    title: Text(
                      "Trash",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 4.h,
                    ),
                    leading: Icon(Icons.settings_outlined, size: 22.r),
                    title: Text(
                      "Settings",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(height: 1.h),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 4.h,
                    ),
                    leading: Obx(
                      () => Icon(
                        !app.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        size: 22.r,
                      ),
                    ),
                    title: Text(
                      "Change Theme",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                    ),
                    onTap: () {
                      app.toggleTheme();
                      Navigator.pop(context);
                    },
                  ),
                  Divider(height: 1.h),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 4.h,
                    ),
                    leading: Icon(Icons.desktop_mac, size: 22.r),
                    title: Text(
                      "Link a Device",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const SearchPage());
                    },
                  ),
                  Divider(height: 1.h),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 4.h,
                    ),
                    leading: Icon(
                      Icons.logout,
                      color: AppColors.danger,
                      size: 22.r,
                    ),
                    title: Text(
                      "Log Out",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: add your logout logic here
                    },
                  ),
                ],
              ),
            ),

            // Version at the bottom
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                "Obsidian  v1.0.0",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
