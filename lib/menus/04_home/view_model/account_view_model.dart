import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/view_utils/view_dialog_util.dart';

class AccountViewModel extends GetxController {
  final userName = 'Axel Darmawan'.obs;
  final userId = 'axel.darmawan@example.com'.obs;
  final appVersion = '-'.obs;
  final RxBool isDarkMode = false.obs;

  @override
  void onInit(){
    super.onInit();
    Future.microtask(() async {
      await initAppVersion();
    });
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    // Tambahkan logika ganti tema di sini jika diperlukan
  }

  Future<void> initAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = "v${packageInfo.version}";
  }

  Future<void> clearAllCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
      }
      // Logika clear session
    } catch (e) {
      log("Logout error: $e");
    }
  }

  void logoutDialog(BuildContext context) {
    ViewDialogUtil().showYesNoActionDialog(
      "Are you sure you want to logout?",
      "Logout",
      "Cancel",
      "assets/images/question.gif",
      null,
      context,
      (dynamic model) async {
        await clearAllCache();
        Get.offAllNamed('/login');
      },
    );
  }
}