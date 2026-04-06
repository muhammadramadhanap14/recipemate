import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/utils/constant_var.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/model_response/register_response.dart';
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
        _fail(l10n.stNoConnectionMessage);
        AppSnackbar.show(
          title: l10n.stError,
          message: l10n.stNoConnectionMessage,
        );
        return;
      }
      final result = await apiRepository.postApiRegister(
        fullname.value,
        email.value,
        password.value,
      );
      debugPrint("result: $result");
      if (result == null) {
        _fail(l10n.stInternalServerError);
        AppSnackbar.show(
          title: l10n.stError,
          message: l10n.stInternalServerError,
        );
        return;
      }
      final response = RegisterResponse.fromJson(result);
      final isSuccess = response.status == ConstantVar.stSuccess;
      final message = response.message;
      if (isSuccess) {
        AppSnackbar.show(
          title: l10n.stSuccess,
          message: message,
        );
        Get.offNamed('/login');
      } else {
        _fail(message);
        AppSnackbar.show(
          title: l10n.stFailed,
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