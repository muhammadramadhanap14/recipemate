import 'package:get/get.dart';

class PreferenceFoodViewModel extends GetxController {

  final RxString name = ''.obs;
  final RxString age = ''.obs;
  final RxList<String> selectedDietary = <String>[].obs;
  final RxList<String> selectedFavoriteCategories = <String>[].obs;
  final RxBool isLoading = false.obs;

  void setName(String value) {
    name.value = value;
  }

  void setAge(String value) {
    age.value = value;
  }

  bool get isStep1Valid {
    return name.value.isNotEmpty && age.value.isNotEmpty;
  }

  List<String> get dietaryList => selectedDietary;

  void toggleDietary(String item) {
    if (selectedDietary.contains(item)) {
      selectedDietary.remove(item);
    } else {
      selectedDietary.add(item);
    }
  }

  bool isDietarySelected(String item) {
    return selectedDietary.contains(item);
  }

  bool get isStep2Valid {
    return selectedDietary.isNotEmpty;
  }

  List<String> get favoriteList => selectedFavoriteCategories;

  void toggleFavorite(String item) {
    if (selectedFavoriteCategories.contains(item)) {
      selectedFavoriteCategories.remove(item);
    } else {
      selectedFavoriteCategories.add(item);
    }
  }

  bool isFavoriteSelected(String item) {
    return selectedFavoriteCategories.contains(item);
  }

  bool get isStep3Valid {
    return selectedFavoriteCategories.isNotEmpty;
  }

  Future<void> finishOnboarding() async {
    isLoading.value = true;
    try {
      /// nanti simpan SQLite disini
      final String finalName = name.value;
      final String finalAge = age.value;

      final List<String> dietary =
      selectedDietary.toList();

      final List<String> favorites = selectedFavoriteCategories.toList();

      /// simulasi delay
      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      /// navigate ke home
      Get.offAllNamed('/home');
    }
    catch (e) {
      Get.snackbar(
        "Error",
        "Failed to finish onboarding",
      );
    }
    finally {
      isLoading.value = false;
    }
  }
}