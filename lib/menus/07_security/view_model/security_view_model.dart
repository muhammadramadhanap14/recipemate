import 'package:get/get.dart';

class SecurityViewModel extends GetxController {
  final userName = 'Axel Darmawan'.obs;
  final userId = 'axel.darmawan@recipemate.io'.obs;

  final RxBool isFaceIdEnabled = true.obs;
  final RxBool isFingerprintEnabled = false.obs;

  void toggleFaceId(bool value) => isFaceIdEnabled.value = value;
  void toggleFingerprint(bool value) => isFingerprintEnabled.value = value;
}