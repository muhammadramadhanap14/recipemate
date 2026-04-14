import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:recipemate/utils/view_utils/app_snackbar.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class AccountViewModel extends GetxController {
  final DataSessionUtilController session;
  final fullName = ''.obs;
  final emailId = ''.obs;
  final appVersion = '-'.obs;
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  RxString currentLanguage = "".obs;
  RxString currentTheme = "".obs;
  final ImagePicker _picker = ImagePicker();

  AccountViewModel({
    required this.session
  });

  @override
  void onInit(){
    super.onInit();
    initializeLanguage();
    initializeTheme();
    getUserFullName();
    getUserEmail();
    Future.microtask(() async {
      await initAppVersion();
    });
  }

  Future<void> getUserFullName() async {
    await session.loadFullName();
    fullName.value = session.stFullName.value;
  }

  Future<void> getUserEmail() async {
    await session.loadEmail();
    emailId.value = session.stEmail.value;
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
      AppSnackbar.show(
        title: l10n.stError,
        message: l10n.stReasonFailedPhoto + e.toString()
      );
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
    final savedTheme = session.stTheme.value;
    if (savedTheme == 'light') {
      themeMode.value = ThemeMode.light;
      currentTheme.value = "Light";
    } else if (savedTheme == 'dark') {
      themeMode.value = ThemeMode.dark;
      currentTheme.value = "Dark";
    } else {
      themeMode.value = ThemeMode.system;
      currentTheme.value = "Default System";
    }
  }

  void changeTheme(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    String themeStr = 'system';
    switch (mode) {
      case ThemeMode.system:
        currentTheme.value = "Default System";
        themeStr = 'system';
        break;
      case ThemeMode.light:
        currentTheme.value = "Light";
        themeStr = 'light';
        break;
      case ThemeMode.dark:
        currentTheme.value = "Dark";
        themeStr = 'dark';
        break;
    }
    await session.setLastTheme(themeStr);
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
      onSelected: (Locale? locale, String label) async {
        if (locale == null) {
          Get.updateLocale(Get.deviceLocale ?? const Locale('en'));
          currentLanguage.value = "Default System";
          await session.setLastLanguage("");
        } else {
          Get.updateLocale(locale);
          currentLanguage.value = label;
          await session.setLastLanguage(locale.languageCode);
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
      onPositiveClick: () async {
        await session.logout();
        Get.offAllNamed('/login');
      },
    );
  }

  void navigateToSecurityPage(BuildContext context) {
    Get.toNamed('/security');
  }
}