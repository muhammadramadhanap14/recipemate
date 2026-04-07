import 'package:get/get.dart';
import '../../../models/model_response/search_recipes_response.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/data_session_util_controller.dart';

class HomeViewModel extends GetxController {
  final ApiRepository apiRepository;
  final DataSessionUtilController session;
  final RxString userName = 'Axel Darmawan'.obs;

  HomeViewModel({
    required this.apiRepository,
    required this.session,
  });

  final RxList<Results> searchResults = <Results>[].obs;
  final RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> searchRecipes(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    try {
      final response = await apiRepository.getRecipesComplexSearch(query: query);
      if (response != null) {
        final searchResponse = SearchRecipesResponse.fromJson(response);
        searchResults.assignAll(searchResponse.results ?? []);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch recipes: $e");
    } finally {
      isSearching.value = false;
    }
  }
}