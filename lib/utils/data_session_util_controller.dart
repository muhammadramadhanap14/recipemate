import 'dart:io';
import 'package:get/get.dart';
import '../utils/data_session_util.dart';

class DataSessionUtilController extends GetxController {
  final DataSessionUtil dataSessionUtil;
  final RxBool isFingerprintEnabled = false.obs;
  final Rx<File?> profileImage = Rx<File?>(null);

  DataSessionUtilController({
    required this.dataSessionUtil
  });

  @override
  void onInit() {
    super.onInit();
    loadFingerprint();
    loadProfileImage();
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
}