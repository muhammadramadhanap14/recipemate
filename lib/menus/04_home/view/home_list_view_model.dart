import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:recipemate/models/model_response/search_recipes_response.dart';
import 'package:recipemate/repository/api_repository.dart';

class HomeListViewModel extends GetxController {
  final ApiRepository apiRepository;
  final String mode;

  final RxList<dynamic> recipes = <dynamic>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxString selectedCategory = ''.obs;

  final List<String> popularCategories = [
    'Salad',
    'Pasta',
    'Pizza',
    'Burger',
    'Steak',
    'Dessert',
    'Sushi',
    'Tacos',
    'Drink',
  ];

  HomeListViewModel({required this.apiRepository, required this.mode});

  @override
  void onInit() {
    super.onInit();
    _loadInitialRecipes();
  }

  Future<void> _loadInitialRecipes() async {
    if (mode == 'popular') {
      await getRandomRecipes(number: 8);
    } else {
      await getRandomRecipes(number: 8);
    }
  }

  Future<void> getRandomRecipes({int number = 8}) async {
    isLoading.value = true;
    isSearching.value = false;
    selectedCategory.value = '';
    try {
      final response = await apiRepository.getRandomRecipes(number: number);
      if (response != null && response['recipes'] != null) {
        recipes.assignAll(response['recipes'] ?? []);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching random recipes: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchByCategory(String category) async {
    if (category.isEmpty) return;

    selectedCategory.value = category;
    isSearching.value = true;
    isLoading.value = false;

    try {
      final response = await apiRepository.getRecipesComplexSearch(
        query: category,
        number: 8,
      );
      if (response != null) {
        final searchResponse = SearchRecipesResponse.fromJson(response);
        recipes.assignAll(searchResponse.results ?? []);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error searching recipes for category $category: $e');
      }
      recipes.clear();
    } finally {
      isSearching.value = false;
    }
  }
}
