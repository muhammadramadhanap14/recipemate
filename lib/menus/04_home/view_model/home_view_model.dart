import 'package:get/get.dart';
import '../../../models/model_response/search_recipes_response.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/data_session_util_controller.dart';

class HomeViewModel extends GetxController {
  final ApiRepository apiRepository;
  final DataSessionUtilController session;
  final RxString userName = ''.obs;
  final RxList<Results> searchResults = <Results>[].obs;
  final RxBool isSearching = false.obs;

  HomeViewModel({
    required this.apiRepository,
    required this.session,
  });

  @override
  void onInit() {
    super.onInit();
    getUserName();
  }

  Future<void> getUserName() async {
    await session.loadFullName();
    userName.value = session.stFullName.value;
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

  @override
  void onClose() {
    searchResults.clear();
    isSearching.value = false;
    super.onClose();
  }
}