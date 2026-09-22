import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/repository/firebase_auth_service.dart';
import 'package:recipemate/utils/view_utils/app_snackbar.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/constant_var.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class LoginViewModel extends GetxController {
  final ApiRepository apiRepository;
  final DataSessionUtilController sessionController;
  final BuildContext context;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isDialogShowing = false;

  LoginViewModel({
    required this.apiRepository,
    required this.sessionController,
    required this.context,
  });

  final errMessage = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startConnectivityListener();
    checkInitialConnection();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  void _startConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      checkInitialConnection();
    });
  }

  Future<void> checkInitialConnection() async {
    final hasConnection = await RecipeMateAppUtil.checkConnection();
    if (!hasConnection) {
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    if (_isDialogShowing) return;

    final context = Get.context;
    if (context != null) {
      _isDialogShowing = true;
      ViewDialogUtil().showOneButtonActionDialog(
        AppLocalizations.of(context)!.stNoConnectionMessage,
        AppLocalizations.of(context)!.backBtnTitle,
        ConstantVar.noConnectionGif,
        context,
        null,
        (dynamic val) {
          _isDialogShowing = false;
          checkInitialConnection();
        },
      );
    }
  }

  Future<void> onGoogleLoginPressed() async {
    final l10n = AppLocalizations.of(Get.context!)!;
    if (isLoading.value) return;
    errMessage.value = '';
    isLoading.value = true;
    try {
      final hasConnection = await RecipeMateAppUtil.checkConnection();
      if (!hasConnection) {
        _fail(l10n.stNoConnectionMessage);
        AppSnackbar.show(
          title: l10n.stError,
          message: l10n.stNoConnectionMessage,
        );
        return;
      }

      final authService = Get.find<FirebaseAuthService>();
      final credential = await authService.signInWithGoogle();

      if (credential != null && credential.user != null) {
        await sessionController.onUserLoggedIn();
        AppSnackbar.show(title: l10n.stSuccess, message: l10n.stSuccess);
        Get.offNamed('/home');
      }
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      if (!message.contains('dibatalkan')) {
        _fail(message);
        AppSnackbar.show(title: l10n.stError, message: message);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _fail(String message) {
    errMessage.value = message;
  }
}
