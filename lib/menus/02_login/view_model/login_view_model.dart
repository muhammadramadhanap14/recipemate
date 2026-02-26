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
      /// TODO Check internet connection
      final hasConnection = await RecipeMateAppUtil.checkConnection();
      if (!hasConnection) {
        _fail('No internet connection');
        return;
      }
      /// TODO Replace with real login API when backend ready
      await _mockLoginFlow();
      Get.offNamed('/home');

    }
    catch (e) {
      _fail(e.toString());
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> _mockLoginFlow() async {
    /// TODO Remove this when backend ready

    await Future.delayed(
      const Duration(seconds: 2),
    );

    /// TODO:
    /// Replace with real API call:
    ///
    /// final handset =
    ///   await RecipeMateAppUtil.getUniqueDeviceId();
    ///
    /// final response =
    ///   await apiRepository.postApiLogin(
    ///      username.value,
    ///      password.value,
    ///      handset,
    ///   );
    ///
    /// TODO Parse response
    ///
    /// TODO Validate response code
    ///
    /// TODO Extract user data
    ///
    /// TODO Save to local storage
    ///
    /// Example:
    /// await LocalStorage.saveUser(user);


    /// TODO:
    /// Example local save using SharedPreferences / SQLite
    ///
    /// await LocalStorage.saveLoginSession(
    ///   username: username.value,
    ///   token: "dummy_token",
    /// );
  }

  Future<void> loginTrc() async {
    try {
      final handset = await RecipeMateAppUtil.getUniqueDeviceId();
      final response = await apiRepository.postApiLogin(
        username.value,
        password.value,
        handset,
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