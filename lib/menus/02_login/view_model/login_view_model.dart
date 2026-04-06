import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/utils/view_utils/app_snackbar.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/recipemate_app_util.dart';

class LoginViewModel extends GetxController {
  final ApiRepository apiRepository;
  final DataSessionUtilController sessionController;
  final BuildContext context;

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

  Future<void> onLoginPressed() async {
    final l10n = AppLocalizations.of(Get.context!)!;
    if (isLoading.value) return;
    errMessage.value = '';
    isLoading.value = true;
    try {
      final hasConnection = await RecipeMateAppUtil.checkConnection();
      if (!hasConnection) {
        _fail('Tidak ada koneksi internet');
        AppSnackbar.show(
          title: l10n.stError,
          message: l10n.stNoConnectionMessage
        );
        return;
      }
      final result = await apiRepository.postApiLogin(
        email.value,
        password.value,
      );
      if (result != null && result["token"] != null) {
        final token = result["token"];
        await sessionController.setToken(token);
        Get.offNamed('/home');
      } else {
        final message = result?["message"] ?? "Login gagal";
        _fail(message);
        AppSnackbar.show(
          title: l10n.stFailedLogin,
          message: message
        );
      }
    } catch (e) {
      _fail("Terjadi kesalahan");
      AppSnackbar.show(
        title: l10n.stError,
        message: e.toString()
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _fail(String message) {
    errMessage.value = message;
  }
}