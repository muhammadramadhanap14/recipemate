import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:recipemate/utils/constant_var.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class AccountViewModel extends GetxController {
  final userName = 'Axel Darmawan'.obs;
  final userId = 'axel.darmawan@example.com'.obs;
  final appVersion = '-'.obs;
  final RxBool isDarkMode = false.obs;
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  RxString currentLanguage = "".obs;

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

  void openLanguageDialog() {
    ViewDialogUtil.dialogSelectLanguage(
      context: Get.context!,
      onSelected: (Locale? locale, String label) {
        final newLocale = locale ?? Get.deviceLocale ?? const Locale('en');
        Get.updateLocale(newLocale);
        currentLanguage.value = label;
      },
    );
  }

  void openDialogChangePrefFoodDialog(BuildContext context) {
    ViewDialogUtil().showYesNoActionDialog(
      AppLocalizations.of(context)!.stConfirmChange,
      AppLocalizations.of(context)!.yesBtn,
      AppLocalizations.of(context)!.stCancelTitle,
      ConstantVar.confirmGif,
      null,
      context,
      (dynamic model) async {
        Get.offAllNamed('/preference_food_satu');
      },
    );
  }

  void openLogoutDialog(BuildContext context) {
    ViewDialogUtil().showYesNoActionDialog(
      AppLocalizations.of(context)!.stConfirmLogout,
      AppLocalizations.of(context)!.confirmLogout,
      AppLocalizations.of(context)!.stCancelTitle,
      ConstantVar.confirmGif,
      null,
      context,
      (dynamic model) async {
        Get.offAllNamed('/login');
      },
    );
  }
}