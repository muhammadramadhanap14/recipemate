import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/constant_var.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class AccountViewModel extends GetxController {
  final userName = ''.obs;
  final userId = ''.obs;
  final userPosition = ''.obs;
  final appVersion = '-'.obs;
  final lastLoginDate = ''.obs;
  final lastLoginTime = ''.obs;

  var dataSessionUtil; // nanti hapus

  AccountViewModel({
    required this.dataSessionUtil,
  });

  @override
  void onInit(){
    super.onInit();
    Future.microtask(() async {
      //TODO Get user data juga
      await initAppVersion();
    });
  }

  Future<void> getUserData() async {
    userName.value = await dataSessionUtil.getNameUser();
    userId.value = await dataSessionUtil.getUserId();
    userPosition.value = await dataSessionUtil.getRoleUser();

    final rawLastLogin = await dataSessionUtil.getLastLogin();

    if (rawLastLogin.isNotEmpty) {
      try {
        final DateTime dt = DateFormat(ConstantVar.stYearDateTimeLineFormat).parse(rawLastLogin);

        lastLoginDate.value = DateFormat(ConstantVar.stDateSlashFormat).format(dt);
        lastLoginTime.value = DateFormat(ConstantVar.stTimeFormat).format(dt);

      } catch (e) {
        lastLoginDate.value = rawLastLogin;
        lastLoginTime.value = "-";
      }
    } else {
      lastLoginDate.value = "-";
      lastLoginTime.value = "-";
    }
  }

  Future<void> initAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = "v${packageInfo.version}";
  }

  // TODO CHANGE INTO DELETE LOCAL DB
  Future<void> clearAllCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
      }

      await dataSessionUtil.removeAllValuesExcSAP();
      await dataSessionUtil.verifySecureStorage();

    } catch (e) {
      log("Logout error: $e");
    }
  }

  void logoutDialog(
      String message,
      String positifBtn,
      String negativeBtn,
      String imageParam,
      BuildContext context) {
    ViewDialogUtil().showYesNoActionDialog(
      message,
      positifBtn,
      negativeBtn,
      imageParam,
      null,
      context,
        (dynamic model) async {
        await clearAllCache();
        Get.offAllNamed('/login');
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}