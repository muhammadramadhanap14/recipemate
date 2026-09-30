import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipemate/repository/firebase_auth_service.dart';
import 'package:recipemate/utils/auth_route_resolver.dart';
import 'package:recipemate/utils/auth_validator.dart';
import 'package:recipemate/utils/constant_var.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/app_snackbar.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class RegisterViewModel extends GetxController {
  final ApiRepository apiRepository;
  final BuildContext context;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  final emailError = ''.obs;
  final passwordError = ''.obs;
  final confirmPasswordError = ''.obs;
  final errMessage = ''.obs;
  final isLoading = false.obs;

  RegisterViewModel({required this.apiRepository, required this.context});

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
    _connectivitySubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
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

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  bool _validateInput(AppLocalizations l10n) {
    emailError.value = AuthValidator.validateEmail(emailController.text, l10n) ?? '';
    passwordError.value = AuthValidator.validatePassword(passwordController.text, l10n, isRegister: true) ?? '';
    confirmPasswordError.value = AuthValidator.validateConfirmPassword(passwordController.text, confirmPasswordController.text, l10n) ?? '';
    return emailError.value.isEmpty && passwordError.value.isEmpty && confirmPasswordError.value.isEmpty;
  }

  Future<void> onEmailRegisterPressed() async {
    final l10n = AppLocalizations.of(Get.context!)!;
    if (!_validateInput(l10n)) return;
    if (isLoading.value) return;
    errMessage.value = '';
    isLoading.value = true;

    try {
      final hasConnection = await RecipeMateAppUtil.checkConnection();
      if (!hasConnection) {
        _fail(l10n.stNoConnectionMessage);
        AppSnackbar.show(title: l10n.stError, message: l10n.stNoConnectionMessage);
        return;
      }

      final authService = Get.find<FirebaseAuthService>();
      final credential = await authService.registerWithEmail(
        emailController.text,
        passwordController.text,
      );

      if (credential != null && credential.user != null) {
        final route = await AuthRouteResolver.resolveRoute(credential.user);
        if (route == '/home') {
          final sessionController = Get.find<DataSessionUtilController>();
          await sessionController.onUserLoggedIn();
        }
        AppSnackbar.show(title: l10n.stSuccess, message: l10n.stEmailVerificationSent);
        Get.offAllNamed(route);
      }
    } on FirebaseAuthException catch (e) {
      String msg = e.message ?? '';
      if (e.code == 'email-already-in-use') {
        msg = l10n.stEmailAlreadyInUse;
      }
      _fail(msg);
      AppSnackbar.show(title: l10n.stError, message: msg);
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
