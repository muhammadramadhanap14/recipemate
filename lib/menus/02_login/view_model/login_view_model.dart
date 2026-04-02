import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/recipemate_app_util.dart';

class LoginViewModel extends GetxController {
  final ApiRepository apiRepository;
  final BuildContext context;

  LoginViewModel({
    required this.apiRepository,
    required this.context,
  });

  final username = ''.obs;
  final password = ''.obs;
  final errMessage = ''.obs;
  final isLoading = false.obs;
  final isValidButton = false.obs;
  final isObscureText = true.obs;

  void setUsername(String value) {
    username.value = value.trim();
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
    /// TODO replace with real validation
    isValidButton.value = username.value.isNotEmpty && password.value.length >= 4;
  }

  Future<void> onLoginPressed() async {
  if (isLoading.value) return;
  errMessage.value = '';
  isLoading.value = true;

  try {
    final hasConnection = await RecipeMateAppUtil.checkConnection();
    if (!hasConnection) {
      _fail('No internet connection');

      Get.snackbar(
        "Error",
        "Tidak ada koneksi internet",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Map<String, dynamic>? result;

    /// 🔥 1. COBA API DULU
    try {
      result = await apiRepository.postApiLogin(
        username.value,
        password.value,
      );
    } catch (e) {
      print("API error, fallback ke mock");
    }

    /// 🔥 2. CEK HASIL API
    if (result != null && result["token"] != null) {
      /// ✅ LOGIN DARI API
      Get.offNamed('/preference_food_satu');
      return;
    }

    /// 🔥 3. MOCK FALLBACK
    await Future.delayed(const Duration(milliseconds: 500));

    if (username.value == "axel@gmail.com" &&
        password.value == "123") {

      /// ✅ LOGIN MOCK
      Get.offNamed('/preference_food_satu');

    } else {
      /// ❌ SEMUA GAGAL
      final message = result?["message"] ?? "Email atau password salah";

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
    _fail(e.toString());

    Get.snackbar(
      "Error",
      "Terjadi kesalahan",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}

  Future<void> loginTrc(BuildContext context) async {
    try {
      final handset = await RecipeMateAppUtil.getUniqueDeviceId();
      final response = await apiRepository.postApiLogin(
        username.value,
        password.value,
        
      );
      /// TODO Parse JSON
      ///
      /// Example:
      ///
      /// final loginResponse =
      ///    LoginResponse.fromJson(response);
      ///
      /// if (!loginResponse.success)
      ///    throw Exception(loginResponse.message);

      /// TODO Save user to local DB
      ///
      /// await UserLocalRepository.saveUser(
      ///   loginResponse.user,
      /// );
    }
    catch (e) {
      rethrow;
    }
  }

  void _fail(String message) {
    errMessage.value = message;
  }
}