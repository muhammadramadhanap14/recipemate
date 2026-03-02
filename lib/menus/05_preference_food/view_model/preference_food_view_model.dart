import 'package:get/get.dart';

class PreferenceFoodViewModel extends GetxController {

  final RxString name = ''.obs;
  final RxString age = ''.obs;
  final RxString height = ''.obs;
  final RxString weight = ''.obs;
  final RxList<String> selectedDietary = <String>[].obs;
  final RxList<String> selectedStyleDietary = <String>[].obs;
  final RxBool isLoading = false.obs;

  void setName(String value) => name.value = value;
  void setAge(String value) => age.value = value;
  void setHeight(String value) => height.value = value;
  void setWeight(String value) => weight.value = value;

  // Step 1
  bool get isStep1Valid {
    return name.value.isNotEmpty && age.value.isNotEmpty && height.value.isNotEmpty && weight.value.isNotEmpty;
  }

  // Step 2
  List<String> get dietaryList => selectedDietary;
  bool isDietarySelected(String item) => selectedDietary.contains(item);
  bool get isStep2Valid => selectedDietary.isNotEmpty;
  void toggleDietary(String item) {
    if (selectedDietary.contains(item)) {
      selectedDietary.remove(item);
    } else {
      selectedDietary.add(item);
    }
  }

  // Step 3
  List<String> get styleDietaryList => selectedStyleDietary;
  bool isStyleDietarySelected(String item) => selectedStyleDietary.contains(item);
  bool get isStep3Valid => selectedStyleDietary.isNotEmpty;
  void toggleStyleDietary(String item) {
    if (selectedStyleDietary.contains(item)) {
      selectedStyleDietary.remove(item);
    } else {
      selectedStyleDietary.add(item);
    }
  }

  Future<void> finishOnboarding() async {
    isLoading.value = true;
    try {
      //TODO logic simpan all data ke local
      await Future.delayed(const Duration(milliseconds: 800));
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar("Error", "Failed to finish onboarding");
    } finally {
      isLoading.value = false;
    }
  }
}