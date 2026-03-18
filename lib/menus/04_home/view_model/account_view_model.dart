import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class AccountViewModel extends GetxController {
  final userName = 'Axel Darmawan'.obs;
  final userId = 'axel.darmawan@example.com'.obs;
  final appVersion = '-'.obs;
  final RxBool isDarkMode = false.obs;
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  RxString currentLanguage = "".obs;
  RxString currentTheme = "".obs;

  @override
  void onInit(){
    super.onInit();
    initializeLanguage();
    initializeTheme();
    Future.microtask(() async {
      await initAppVersion();
    });
  }

  Future<void> initAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = "v${packageInfo.version}";
  }

  void initializeLanguage() {
    if (Get.locale == null || Get.locale == Get.deviceLocale) {
      currentLanguage.value = "Default System";
    } else {
      if (Get.locale!.languageCode == 'id') {
        currentLanguage.value = "Indonesia";
      } else if (Get.locale!.languageCode == 'en') {
        currentLanguage.value = "English";
      } else {
        currentLanguage.value = "Default System";
      }
    }
  }

  void initializeTheme() {
    switch (themeMode.value) {
      case ThemeMode.system:
        currentTheme.value = "Default System";
        break;
      case ThemeMode.light:
        currentTheme.value = "Light";
        break;
      case ThemeMode.dark:
        currentTheme.value = "Dark";
        break;
    }
  }

  void changeTheme(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    switch (mode) {
      case ThemeMode.system:
        currentTheme.value = "Default System";
        break;
      case ThemeMode.light:
        currentTheme.value = "Light";
        break;
      case ThemeMode.dark:
        currentTheme.value = "Dark";
        break;
    }
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
        if (locale == null) {
          Get.updateLocale(Get.deviceLocale ?? const Locale('en'));
          currentLanguage.value = "Default System";
        } else {
          Get.updateLocale(locale);
          currentLanguage.value = label;
        }
      },
    );
  }

  void openChangePrefFoodDialog(BuildContext context) {
    ViewDialogUtil().showConfirmDialog(
      title: "${AppLocalizations.of(context)!.stChangeData}?",
      icon: Icons.edit_attributes,
      context: context,
      message: AppLocalizations.of(context)!.stConfirmChange,
      positiveTitle: AppLocalizations.of(context)!.yesBtn,
      negativeTitle: AppLocalizations.of(context)!.stCancelTitle,
      onPositiveClick: () {
        Get.offAllNamed('/preference_food_satu');
      },
    );
  }

  void openLogoutDialog(BuildContext context) {
    ViewDialogUtil().showConfirmDialog(
      title: "${AppLocalizations.of(context)!.logout}?",
      icon: Icons.logout,
      context: context,
      message: AppLocalizations.of(context)!.stConfirmLogout,
      positiveTitle: AppLocalizations.of(context)!.confirmLogout,
      negativeTitle: AppLocalizations.of(context)!.stCancelTitle,
      onPositiveClick: () {
        Get.offAllNamed('/login');
      },
    );
  }

  void navigateToSecurityPage(BuildContext context) {
    Get.toNamed('/security');
  }
}