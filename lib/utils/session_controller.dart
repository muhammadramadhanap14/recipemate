import 'dart:io';
import 'package:get/get.dart';
import '../utils/data_session_util.dart';

class DataSessionUtilController extends GetxController {
  final DataSessionUtil dataSessionUtil;
  final Rx<File?> profileImage = Rx<File?>(null);

  DataSessionUtilController({
    required this.dataSessionUtil
  });

  @override
  void onInit() {
    super.onInit();
    loadProfileImage();
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