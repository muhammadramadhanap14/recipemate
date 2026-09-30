import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipemate/repository/firebase_auth_service.dart';
import 'package:recipemate/utils/auth_route_resolver.dart';
import 'package:recipemate/utils/auth_validator.dart';
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

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  final isPasswordHidden = true.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final errMessage = ''.obs;
  final isLoading = false.obs;

  LoginViewModel({
    required this.apiRepository,
    required this.sessionController,
    required this.context,
  });

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
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
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

  bool _validateInput(AppLocalizations l10n) {
    emailError.value = AuthValidator.validateEmail(emailController.text, l10n) ?? '';
    passwordError.value = AuthValidator.validatePassword(passwordController.text, l10n) ?? '';
    return emailError.value.isEmpty && passwordError.value.isEmpty;
  }

  Future<void> onEmailLoginPressed() async {
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
      final credential = await authService.signInWithEmail(
        emailController.text,
        passwordController.text,
      );

      if (credential != null && credential.user != null) {
        final route = await AuthRouteResolver.resolveRoute(credential.user);
        if (route == '/home') {
          await sessionController.onUserLoggedIn();
          AppSnackbar.show(title: l10n.stSuccess, message: l10n.stSuccess);
        }
        Get.offAllNamed(route);
      }
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      _fail(message);
      AppSnackbar.show(title: l10n.stError, message: message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onForgotPasswordPressed() async {
    final l10n = AppLocalizations.of(Get.context!)!;
    final emailErr = AuthValidator.validateEmail(emailController.text, l10n);
    if (emailErr != null) {
      emailError.value = emailErr;
      AppSnackbar.show(title: l10n.stError, message: emailErr);
      return;
    }
    try {
      final authService = Get.find<FirebaseAuthService>();
      await authService.sendPasswordReset(emailController.text);
      AppSnackbar.show(title: l10n.stSuccess, message: l10n.stPasswordResetSent);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      AppSnackbar.show(title: l10n.stError, message: message);
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
        final route = await AuthRouteResolver.resolveRoute(credential.user);
        if (route == '/home') {
          await sessionController.onUserLoggedIn();
          AppSnackbar.show(title: l10n.stSuccess, message: l10n.stSuccess);
        }
        Get.offAllNamed(route);
      }
    } on AccountExistsException catch (e) {
      isLoading.value = false;
      _showAccountLinkingDialog(e.email, e.pendingCredential);
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

  void _showAccountLinkingDialog(String email, AuthCredential? pendingCredential) {
    final context = Get.context;
    if (context == null || pendingCredential == null) return;
    final l10n = AppLocalizations.of(context)!;
    final passwordController = TextEditingController();

    Get.defaultDialog(
      title: l10n.stLinkAccountTitle,
      content: Column(
        children: [
          Text('${l10n.stLinkAccountPrompt}\n($email)', textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.stPassword),
          ),
        ],
      ),
      textConfirm: l10n.confirmBtn,
      textCancel: l10n.stCancelTitle,
      onConfirm: () async {
        Get.back();
        try {
          isLoading.value = true;
          final authService = Get.find<FirebaseAuthService>();
          await authService.signInWithEmail(email, passwordController.text);
          await authService.linkPendingCredential(pendingCredential);
          final route = await AuthRouteResolver.resolveRoute(FirebaseAuth.instance.currentUser);
          if (route == '/home') {
            await sessionController.onUserLoggedIn();
            AppSnackbar.show(title: l10n.stSuccess, message: l10n.stSuccess);
          }
          Get.offAllNamed(route);
        } catch (e) {
          final message = e.toString().replaceFirst('Exception: ', '');
          AppSnackbar.show(title: l10n.stError, message: message);
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  void _fail(String message) {
    errMessage.value = message;
  }
}
