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
  final username = ''.obs;
  final password = ''.obs;
  final errMessage = ''.obs;
  final isLoading = false.obs;
  final isValidButton = false.obs;
  final isObscureText = true.obs;

  void setFullname(String value) {
    fullname.value = value.trim();
    _validate();
  }

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
    isValidButton.value = fullname.value.isNotEmpty && username.value.isNotEmpty && password.value.length >= 4;
  }

  Future<void> onRegisterPressed() async {
  if (isLoading.value) return;
  errMessage.value = '';
  isLoading.value = true;

  try {
    final hasConnection = await RecipeMateAppUtil.checkConnection();
    if (!hasConnection) {
      _fail('No internet connection');
      return;
    }

    /// 🔥 CALL API REGISTER
    final result = await apiRepository.postApiRegister(
      fullname.value,
      username.value,
      password.value,
    );

    /// 🔥 HANDLE RESPONSE
    if (result != null && result["message"] != null) {
      Get.snackbar("Success", result["message"]);

      /// pindah ke login
      Get.offNamed('/login');
    } else {
      _fail(result?["message"] ?? "Register gagal");
    }

  } catch (e) {
    _fail(e.toString());
  } finally {
    isLoading.value = false;
  }
}

  Future<void> registerTrc(BuildContext context) async {
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