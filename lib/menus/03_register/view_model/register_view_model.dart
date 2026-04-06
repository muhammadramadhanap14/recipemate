import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/recipemate_app_util.dart';

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

    isValidButton.value =
        fullname.value.isNotEmpty &&
            isEmailValid &&
            password.value.length >= 4;
  }

  Future<void> onRegisterPressed() async {
    if (isLoading.value) return;

    errMessage.value = '';
    isLoading.value = true;

    try {
      final hasConnection = await RecipeMateAppUtil.checkConnection();
      if (!hasConnection) {
        _fail('Tidak ada koneksi internet');

        Get.snackbar(
          "Error",
          "Tidak ada koneksi internet",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final result = await apiRepository.postApiRegister(
        fullname.value,
        email.value,
        password.value,
      );

      if (result != null && result["message"] != null) {
        Get.snackbar(
          "Success",
          result["message"],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offNamed('/login');
      } else {
        final message = result?["message"] ?? "Register gagal";
        _fail(message);

        Get.snackbar(
          "Register Gagal",
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _fail("Terjadi kesalahan");

      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _fail(String message) {
    errMessage.value = message;
  }
}