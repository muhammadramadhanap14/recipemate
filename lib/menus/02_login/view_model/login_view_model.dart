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

  void setNik(String value) {
    username.value = value.trim();
    _validate();
  }

  void setPass(String value) {
    password.value = value;
    _validate();
  }

  void _validate() {
    isValidButton.value =
        username.value.isNotEmpty && password.value.length >= 4;
  }

  void setObscureTextPass() {
    isObscureText.value = !isObscureText.value;
  }

  Future<void> onLoginPressed() async {
    errMessage.value = '';
    isLoading.value = true;

    final hasConnection = await RecipeMateAppUtil.checkConnection();
    if (!hasConnection) {
      isLoading.value = false;
      errMessage.value = 'No internet connection';
      return;
    }

    await loginTrc(username.value, password.value, context);
  }

  Future<void> loginTrc(String nik, String pass, BuildContext context) async {
    try {
      final handset = await RecipeMateAppUtil.getUniqueDeviceId();

      final response = await apiRepository.postApiLogin(
        nik,
        pass,
        handset
      );

      if (response == null) {
        _fail('Internal server error');
        return;
      }

      // final loginResponse = LoginResponse.fromJson(jsonDecode(response));
      //
      // if (loginResponse.code != ConstantVar.intSuccess ||
      //     loginResponse.datas?.isEmpty != false) {
      //   _fail(loginResponse.message ?? 'Login failed');
      //   return;
      // }
      
      // TODO Save data user to local DB

      Get.offNamed('/home');
    } catch (e) {
      _fail(e.toString());
    }
  }

  void _fail(String message) {
    isLoading.value = false;
    errMessage.value = message;
  }
}