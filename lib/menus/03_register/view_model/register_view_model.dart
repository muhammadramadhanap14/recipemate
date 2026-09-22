import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/repository/firebase_auth_service.dart';
import 'package:recipemate/utils/constant_var.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/app_snackbar.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class RegisterViewModel extends GetxController {
  final ApiRepository apiRepository;
  final BuildContext context;
  final fullnameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  RegisterViewModel({required this.apiRepository, required this.context});

  final fullname = ''.obs;
  final email = ''.obs;
  final password = ''.obs;

  final errMessage = ''.obs;
  final isLoading = false.obs;
  final isValidButton = false.obs;
  final isObscureText = true.obs;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isDialogShowing = false;

  @override
  void onInit() {
    super.onInit();
    _startConnectivityListener();
    checkInitialConnection();
  }

  @override
  void onClose() {
    fullnameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
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

  void setFullname(String value) {
    fullname.value = value.trim();
    _validate();
  }

  void setEmail(String value) {
    email.value = value.trim();
    _validate();
  }

  void setPassword(String value) {
    password.value = value;
    _validate();
  }

  void togglePasswordVisibility() {
    isObscureText.toggle();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email.trim());
  }

  void _validate() {
    final isEmailValid = _isValidEmail(email.value);

    isValidButton.value =
        fullname.value.trim().isNotEmpty && isEmailValid && password.value.length >= 6;
  }

  Future<void> onRegisterPressed() async {
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
      final credential = await authService.registerWithEmail(
        email.value,
        password.value,
      );

      if (credential != null && credential.user != null) {
        await credential.user!.updateDisplayName(fullname.value);
        AppSnackbar.show(title: l10n.stSuccess, message: l10n.stSuccess);
        Get.offNamed('/login');
      } else {
        _fail(l10n.stFailed);
        AppSnackbar.show(title: l10n.stFailed, message: l10n.stFailed);
      }
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      _fail(message);
      AppSnackbar.show(title: l10n.stError, message: message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onGoogleRegisterPressed() async {
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
      final userCredential = await authService.signInWithGoogle();

      if (userCredential == null || userCredential.user == null) {
        _fail(l10n.stInternalServerError);
        AppSnackbar.show(
          title: l10n.stFailed,
          message: l10n.stInternalServerError,
        );
        return;
      }

      AppSnackbar.show(
        title: l10n.stSuccess,
        message: 'Berhasil daftar dengan Google',
      );
      Get.offAllNamed('/home'); // arahkan ke halaman utama, bukan /login
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      _fail(message);
      AppSnackbar.show(title: l10n.stError, message: message);
    } finally {
      isLoading.value = false;
    }
  }

  void _fail(String message) {
    errMessage.value = message;
  }
}
