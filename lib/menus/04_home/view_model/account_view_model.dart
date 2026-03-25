import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:recipemate/utils/data_session_util.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class AccountViewModel extends GetxController {
  final DataSessionUtil dataSessionUtil;
  final DataSessionUtilController session = Get.find<DataSessionUtilController>();
  final userName = 'Axel Darmawan'.obs;
  final userId = 'axel.darmawan@example.com'.obs;
  final appVersion = '-'.obs;
  final RxBool isDarkMode = false.obs;
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  RxString currentLanguage = "".obs;
  RxString currentTheme = "".obs;
  final ImagePicker _picker = ImagePicker();

  AccountViewModel({
    required this.dataSessionUtil
  });

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

  Future<void> pickImage(ImageSource source) async {
    final l10n = AppLocalizations.of(Get.context!)!;
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        await session.setProfileImage(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(l10n.stError, l10n.stReasonFailedPhoto + e.toString());
    }
  }

  Future<void> removeImage() async {
    await session.clearProfileImage();
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