import 'dart:io';
import 'package:get/get.dart';
import 'data_session_util.dart';

class DataSessionUtilController extends GetxController {
  final DataSessionUtil dataSessionUtil;
  final RxBool isFingerprintEnabled = false.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxString stToken = "".obs;
  final RxString stFullName = "".obs;
  final RxString stEmail = "".obs;
  final RxString stTheme = "".obs;
  final RxString stLanguage = "".obs;

  DataSessionUtilController({
    required this.dataSessionUtil
  });

  @override
  void onInit() {
    super.onInit();
    loadFingerprint();
    loadProfileImage();
    loadToken();
    loadFullName();
    loadEmail();
    loadTheme();
    loadLanguage();
  }

  Future<void> loadEmail() async {
    final email = await dataSessionUtil.getEmail();
    stEmail.value = email ?? "";
  }

  Future<void> setEmail(String email) async {
    stEmail.value = email;
    await dataSessionUtil.setEmail(email);
  }

  Future<void> loadFullName() async {
    final fullName = await dataSessionUtil.getFullName();
    stFullName.value = fullName ?? "";
  }

  Future<void> setFullName(String fullName) async {
    stFullName.value = fullName;
    await dataSessionUtil.setFullName(fullName);
  }

  Future<void> loadToken() async {
    final token = await dataSessionUtil.getToken();
    stToken.value = token ?? "";
  }

  Future<void> setToken(String token) async {
    stToken.value = token;
    await dataSessionUtil.setToken(token);
  }

  Future<void> loadFingerprint() async {
    isFingerprintEnabled.value = await dataSessionUtil.getFingerprint();
  }

  Future<void> setFingerprint(bool value) async {
    isFingerprintEnabled.value = value;
    await dataSessionUtil.setFingerprint(value);
  }

  Future<void> loadProfileImage() async {
    final path = await dataSessionUtil.getProfileImagePath();
    if (path != null && path.isNotEmpty) {
      profileImage.value = File(path);
    } else {
      profileImage.value = null;
    }
  }

  Future<void> setProfileImage(String path) async {
    profileImage.value = File(path);
    await dataSessionUtil.setProfileImagePath(path);
  }

  Future<void> clearProfileImage() async {
    profileImage.value = null;
    await dataSessionUtil.clearProfileImagePath();
  }

  Future<void> setSavedPassword(String password) async {
    await dataSessionUtil.setPassword(password);
  }

  Future<String?> getSavedPassword() async {
    return await dataSessionUtil.getPassword();
  }

  Future<void> loadTheme() async {
    final theme = await dataSessionUtil.getLastTheme();
    stTheme.value = theme ?? "";
  }

  Future<void> setLastTheme(String theme) async {
    stTheme.value = theme;
    await dataSessionUtil.setLastTheme(theme);
  }

  Future<String?> getLastTheme() async {
    return await dataSessionUtil.getLastTheme();
  }

  Future<void> loadLanguage() async {
    final language = await dataSessionUtil.getLastLanguage();
    stLanguage.value = language ?? "";
  }

  Future<void> setLastLanguage(String language) async {
    stLanguage.value = language;
    await dataSessionUtil.setLastLanguage(language);
  }

  Future<String?> getLastLanguage() async {
    return await dataSessionUtil.getLastLanguage();
  }

  Future<void> logout() async {
    await dataSessionUtil.clearSession();
    isFingerprintEnabled.value = false;
    profileImage.value = null;
    stToken.value = "";
    stFullName.value = "";
    stEmail.value = "";
  }
}