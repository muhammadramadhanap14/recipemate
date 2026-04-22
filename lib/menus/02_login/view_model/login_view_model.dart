import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:recipemate/utils/view_utils/app_snackbar.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/model_response/login_response.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/constant_var.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/recipemate_app_util.dart';

class LoginViewModel extends GetxController {
  final ApiRepository apiRepository;
  final DataSessionUtilController sessionController;
  final BuildContext context;
  final LocalAuthentication auth = LocalAuthentication();

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
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    final bool hasFingerprint = sessionController.isFingerprintEnabled.value;
    final bool canCheck = await auth.canCheckBiometrics || await auth.isDeviceSupported();
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
    isObscureText.value = !isObscureText.value;
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
            message: l10n.stLoginFingerprintErrorMessage
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
      final result = await apiRepository.postApiLogin(
        email.value,
        password.value,
      );
      if (result == null) {
        _fail(l10n.stInternalServerError);
        AppSnackbar.show(
          title: l10n.stError,
          message: l10n.stInternalServerError,
        );
        return;
      }
      final response = LoginResponse.fromJson(result);
      final isSuccess = response.status == ConstantVar.stSuccess;
      final message = response.message ?? l10n.stFailedLogin;
      if (isSuccess && response.data?.token != null) {
        await sessionController.setToken(response.data?.token ?? '');
        await sessionController.setFullName(response.data?.user?.name ?? '');
        await sessionController.setEmail(response.data?.user?.email ?? '');
        await sessionController.setSavedPassword(password.value);
        await sessionController.onUserLoggedIn();
        AppSnackbar.show(
          title: l10n.stSuccess,
          message: message,
        );
        Get.offNamed('/home');
      } else {
        _fail(message);
        AppSnackbar.show(
          title: l10n.stFailedLogin,
          message: message,
        );
      }
    } catch (e) {
      final message = e.toString();
      _fail(message);
      AppSnackbar.show(
        title: l10n.stError,
        message: message,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _fail(String message) {
    errMessage.value = message;
  }
}