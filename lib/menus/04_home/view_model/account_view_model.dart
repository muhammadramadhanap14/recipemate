import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:recipemate/utils/constant_var.dart';

import '../../../utils/view_utils/view_dialog_util.dart';

class AccountViewModel extends GetxController {
  final userName = 'Axel Darmawan'.obs;
  final userId = 'axel.darmawan@example.com'.obs;
  final appVersion = '-'.obs;
  final RxBool isDarkMode = false.obs;
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit(){
    super.onInit();
    Future.microtask(() async {
      await initAppVersion();
    });
  }

  Future<void> initAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = "v${packageInfo.version}";
  }

  void changeTheme(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
  }

  void openThemeDialog(BuildContext context) async {
    final result = await ViewDialogUtil.dialogSelectTheme(context, themeMode.value);
    if (result != null) {
      changeTheme(result);
    }
  }

  void openDialogChangePrefFood(BuildContext context) {
    ViewDialogUtil().showYesNoActionDialog(
      ConstantVar.stChangePrefFood,
      ConstantVar.stEditData,
      ConstantVar.stCancelTitle,
      ConstantVar.confirmGif,
      null,
      context,
      (dynamic model) async {
        Get.offAllNamed('/preference_food_satu');
      },
    );
  }

  void logoutDialog(BuildContext context) {
    ViewDialogUtil().showYesNoActionDialog(
      ConstantVar.stConfirmLogout,
      ConstantVar.confirmLogout,
      ConstantVar.stCancelTitle,
      ConstantVar.confirmGif,
      null,
      context,
      (dynamic model) async {
        Get.offAllNamed('/login');
      },
    );
  }
}