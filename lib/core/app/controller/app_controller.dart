import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyc_test/main.dart';

// TODO this is the main Controller of the App that stay active as long as the app is working :3
class AppController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  bool get isDarkMode {
    if (themeMode.value == ThemeMode.system) {
      return Get.isDarkMode;
    }
    return themeMode.value == ThemeMode.dark;
  }

  void toggleTheme() {
    if (isDarkMode) {
      logger.e("theme changeinggg");
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.dark;
    }
    Get.changeThemeMode(themeMode.value);
  }
}
