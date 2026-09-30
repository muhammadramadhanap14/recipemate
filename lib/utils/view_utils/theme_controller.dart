import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  void initTheme(String? themeStr) {
    // ThemeMode mode;
    // switch (themeStr) {
    //   case 'light':
    //     mode = ThemeMode.light;
    //     break;
    //   case 'dark':
    //     mode = ThemeMode.dark;
    //     break;
    //   default:
    //     mode = ThemeMode.system;
    // }

    // Forced Darkmode
    const mode = ThemeMode.dark;
    themeMode.value = mode;
    Get.changeThemeMode(mode);
  }
}