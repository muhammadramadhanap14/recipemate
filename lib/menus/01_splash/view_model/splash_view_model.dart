import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/constant_var.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class SplashViewModel extends GetxController {
  final BuildContext context;
  final startIconAnimation = false.obs;
  final startTextAnimation = false.obs;
  final isLoading = false.obs;
  final splashDuration = const Duration(milliseconds: 3500);

  SplashViewModel({
    required this.context,
  });

  @override
  void onInit() {
    super.onInit();
    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    Future.delayed(const Duration(milliseconds: 400), () {
      startIconAnimation.value = true;
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      startTextAnimation.value = true;
    });
    await initCheckConnection();
  }

  Future<void> initCheckConnection() async {
    final valConnection = await RecipeMateAppUtil.checkConnection();
    if (valConnection) {
      isLoading.value = true;
      await Future.delayed(splashDuration);
      Get.offAllNamed('/login');
    } else {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   ViewDialogUtil().showOneButtonActionDialog(
      //     AppLocalizations.of(context)!.stNoConnectionMessage,
      //     AppLocalizations.of(context)!.backBtnTitle,
      //     ConstantVar.noConnectionGif,
      //     context,
      //     null,
      //         (dynamic) {},
      //   );
      // });
    }
  }

}