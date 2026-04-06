import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    if (isLoading.value) return;

    errMessage.value = '';
    isLoading.value = true;

    try {
      /// 🔍 Check internet
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

      /// 🔥 CALL API
      final result = await apiRepository.postApiLogin(
        email.value,
        password.value,
      );

      /// 🔥 VALIDASI RESPONSE
      if (result != null && result["token"] != null) {
        final token = result["token"];

        /// ✅ SIMPAN TOKEN
        await sessionController.setToken(token);

        /// ✅ SUCCESS NAVIGATION
        Get.offNamed('/home');
      } else {
        final message = result?["message"] ?? "Login gagal";
        _fail(message);

        Get.snackbar(
          "Login Gagal",
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
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