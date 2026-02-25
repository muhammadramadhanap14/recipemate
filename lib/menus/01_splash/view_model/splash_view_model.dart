import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/constant_var.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class SplashViewModel extends GetxController {
  final isLoading = false.obs;
  final BuildContext context;

  SplashViewModel({
    required this.context,
  });

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() async {
      await initCheckConnection();
    });
  }

  Future<void> initCheckConnection() async {
    final valConnection = await RecipeMateAppUtil.checkConnection();
    if (valConnection) {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ViewDialogUtil().showOneButtonActionDialog(
            ConstantVar.stNoConnectionMessage,
            ConstantVar.backBtnTitle,
            ConstantVar.noConnectionGif,
            context,
            null, (dynamic) {});
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}