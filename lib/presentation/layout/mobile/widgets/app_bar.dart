import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MobileAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MobileAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  State<MobileAppBar> createState() => _MobileAppBarState();
}

class _MobileAppBarState extends State<MobileAppBar> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Fake delay to show skeleton (replace with your real loading logic)
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      scrolledUnderElevation: 0.0,
      leading: null,
      surfaceTintColor: Colors.transparent,
      forceMaterialTransparency: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Skeletonizer(
        enabled: _isLoading,
        child: Row(
          children: [
            SizedBox(width: 15.w),

            // ==== Avatar with Skeleton ====
            Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () => Scaffold.of(context).openDrawer(),
                  child: CircleAvatar(
                    radius: 20.r,
                    backgroundColor: Colors.blue.shade200,
                    child: ClipOval(
                      child: FancyShimmerImage(
                        imageUrl:
                            // "https://app.requestly.io/delay/2000/avatars.githubusercontent.com/u/124599?v=4",
                            "https://i.pinimg.com/736x/03/eb/d6/03ebd625cc0b9d636256ecc44c0ea324.jpg",
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(width: 10.w),

            // ==== Username + Greeting ====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hello, Bilal",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
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
      ),
      actions: [
        Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu_open_outlined, size: 25.r),
              onPressed: _isLoading
                  ? null
                  : () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
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
