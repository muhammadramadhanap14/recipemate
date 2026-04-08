import 'package:get/get.dart';
import '../../../models/model_response/detail_recipe_response.dart';
import '../../../repository/api_repository.dart';

class HomeDetailViewModel extends GetxController {
  final ApiRepository apiRepository;
  final int recipeId;
  final Rx<DetailRecipeResponse?> recipeDetail = Rx<DetailRecipeResponse?>(null);
  final RxBool isLoading = false.obs;

  HomeDetailViewModel({
    required this.apiRepository,
    required this.recipeId,
  });

  @override
  void onInit() {
    super.onInit();
    getRecipeDetail();
  }

  Future<void> getRecipeDetail() async {
    isLoading.value = true;
    try {
      final response = await apiRepository.getRecipeInformation(recipeId);
      if (response != null) {
        recipeDetail.value = DetailRecipeResponse.fromJson(response);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch recipe detail: $e");
    } finally {
      isLoading.value = false;
    }
  }
}