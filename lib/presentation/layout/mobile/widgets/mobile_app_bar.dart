import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

PreferredSizeWidget mobileAppBar() {
  return AppBar(
    titleSpacing: 0,
    scrolledUnderElevation: 0.0,
    leading: null,
    surfaceTintColor: Colors.transparent,
    forceMaterialTransparency: true,
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        SizedBox(width: 15.w),
        Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.blue.shade200,
                child: ClipOval(
                  child: FancyShimmerImage(
                    imageUrl:
                        "https://app.requestly.io/delay/2000/avatars.githubusercontent.com/u/124599?v=4",
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Hello, Yahiea",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
              ),
              SizedBox(height: 2.h),
              Text(
                getGreeting(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.sp, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    ),
    actions: [
      Builder(
        builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu_open_outlined, size: 25.r),
            onPressed: () =>
                Scaffold.of(context).openDrawer(), // 👈 same as avatar
          );
        },
      ),
      SizedBox(width: 8.w),
    ],
  );
}

String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return "Good Morning! 🌅".tr;
  } else if (hour < 17) {
    return "Good Afternoon! 🌞".tr;
  } else {
    return "Good Evening! 🌙".tr;
  }
}
