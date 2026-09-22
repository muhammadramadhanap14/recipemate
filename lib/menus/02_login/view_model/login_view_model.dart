import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
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
  final LocalAuthentication auth = LocalAuthentication();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isDialogShowing = false;

  LoginViewModel({
    required this.apiRepository,
    required this.sessionController,
    required this.context,
  });

  final email = ''.obs;
  final password = ''.obs;
  final errMessage = ''.obs;
  final isLoading = false.obs;
  final isValidButton = false.obs;
  final isObscureText = true.obs;
  final canUseBiometric = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startConnectivityListener();
    checkInitialConnection();
    _checkBiometricSupport();
  }

  @override
  void onClose() {
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

  Future<void> _checkBiometricSupport() async {
    final bool hasFingerprint = sessionController.isFingerprintEnabled.value;
    final bool canCheck =
        await auth.canCheckBiometrics || await auth.isDeviceSupported();
    canUseBiometric.value = hasFingerprint && canCheck;
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

  void _validate() {
    isValidButton.value = email.value.isNotEmpty && password.value.length >= 4;
  }

  Future<void> loginWithBiometric() async {
    final l10n = AppLocalizations.of(Get.context!)!;
    try {
      final bool authenticated = await auth.authenticate(
        localizedReason: l10n.stLoginFingerprint,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        final savedEmail = sessionController.stEmail.value;
        final savedPassword = await sessionController.getSavedPassword();
        if (savedEmail.isNotEmpty && savedPassword != null) {
          email.value = savedEmail;
          password.value = savedPassword;
          await onLoginPressed();
        } else {
          AppSnackbar.show(
            title: l10n.stError,
            message: l10n.stLoginFingerprintErrorMessage,
          );
        }
      }
    } catch (e) {
      AppSnackbar.show(title: l10n.stError, message: e.toString());
    }
  }

  Future<void> onLoginPressed() async {
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
      final credential = await authService.signInWithEmail(
        email.value,
        password.value,
      );

      if (credential != null && credential.user != null) {
        await sessionController.setSavedPassword(password.value);
        await sessionController.onUserLoggedIn();
        AppSnackbar.show(title: l10n.stSuccess, message: l10n.stSuccess);
        Get.offNamed('/home');
      } else {
        _fail(l10n.stFailedLogin);
        AppSnackbar.show(title: l10n.stFailedLogin, message: l10n.stFailedLogin);
      }
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      _fail(message);
      AppSnackbar.show(title: l10n.stError, message: message);
    } finally {
      isLoading.value = false;
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
