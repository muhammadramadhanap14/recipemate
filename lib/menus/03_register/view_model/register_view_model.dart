import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/app_snackbar.dart';

class RegisterViewModel extends GetxController {
  final ApiRepository apiRepository;
  final BuildContext context;

  RegisterViewModel({
    required this.apiRepository,
    required this.context,
  });

  final fullname = ''.obs;
  final email = ''.obs;
  final password = ''.obs;

  final errMessage = ''.obs;
  final isLoading = false.obs;
  final isValidButton = false.obs;
  final isObscureText = true.obs;

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
    isObscureText.value = !isObscureText.value;
  }

  void _validate() {
    final isEmailValid = email.value.contains("@");
    isValidButton.value = fullname.value.isNotEmpty && isEmailValid && password.value.length >= 4;
  }

  Future<void> onRegisterPressed() async {
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
      final result = await apiRepository.postApiRegister(
        fullname.value,
        email.value,
        password.value,
      );
      if (result != null && result["message"] != null) {
        AppSnackbar.show(
          title: l10n.stSuccess,
          message: result["message"]
        );
        Get.offNamed('/login');
      } else {
        final message = result?["message"] ?? l10n.stFailedRegister;
        _fail(message);
        AppSnackbar.show(
          title: l10n.stFailed,
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