import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/constant_var.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/model_response/search_recipes_response.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/view_utils/view_dialog_util.dart';
import '../../../utils/view_utils/app_snackbar.dart';

class HomeViewModel extends GetxController {
  final ApiRepository apiRepository;
  final DataSessionUtilController session;
  final RxString userName = ''.obs;
  final RxList<Results> searchResults = <Results>[].obs;
  final RxList<dynamic> recommendedRecipes = <dynamic>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool isLoadingRecommended = false.obs;
  final RxBool isFingerprintEnabled = false.obs;
  final RxList<dynamic> autoCompleteResults = <dynamic>[].obs;
  final RxBool isAutoCompleteLoading = false.obs;
  final RxString searchText = ''.obs;
  final RxList<dynamic> foodArticles = <dynamic>[].obs;
  final RxBool isLoadingArticles = false.obs;
  final List<String> articleKeywords = [
    'cooking',
    'healthy',
    'nutrition',
    'food',
    'restaurant',
    'recipe',
    'diet',
    'organic',
    'vegan',
    'gourmet',
  ];

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isDialogShowing = false;

  HomeViewModel({required this.apiRepository, required this.session});

  @override
  void onInit() {
    super.onInit();
    getUserName();
    _startConnectivityListener();
    checkInitialConnection();
    getRecommendedRecipes();
    getDynamicFoodArticles();
    searchController.addListener(() {
      searchText.value = searchController.text;
    });
    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus) {
        autoCompleteResults.clear();
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      checkAndShowFingerprintReminder();
    });
  }

  void _startConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      checkInitialConnection();
    });
  }

  Future<void> checkInitialConnection() async {
    final hasConnection = await RecipeMateAppUtil.checkConnection();
    if (!hasConnection) {
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    if (_isDialogShowing) return;

    final context = Get.context;
    if (context != null) {
      _isDialogShowing = true;
      ViewDialogUtil().showOneButtonActionDialog(
        AppLocalizations.of(context)!.stNoConnectionMessage,
        AppLocalizations.of(context)!.backBtnTitle,
        ConstantVar.noConnectionGif,
        context,
        null,
        (dynamic val) {
          _isDialogShowing = false;
          checkInitialConnection();
        },
      );
    }
  }

  void resetSearch() {
    searchController.clear();
    searchText.value = '';
    searchResults.clear();
    autoCompleteResults.clear();
    isSearching.value = false;
    isAutoCompleteLoading.value = false;
    searchFocusNode.unfocus();
  }

  Future<void> getUserName() async {
    await session.loadFullName();
    userName.value = session.stFullName.value;
  }

  Future<void> getAutoComplete(String query) async {
    if (query.trim().isEmpty) {
      autoCompleteResults.clear();
      return;
    }
    isAutoCompleteLoading.value = true;
    try {
      final response = await apiRepository.getRecipeAutocomplete(query: query);
      if (response != null) {
        autoCompleteResults.assignAll(response);
      }
    } catch (e) {
      debugPrint("Autocomplete error: $e");
    } finally {
      isAutoCompleteLoading.value = false;
    }
  }

  Future<void> searchRecipes(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      autoCompleteResults.clear();
      return;
    }
    autoCompleteResults.clear();
    searchFocusNode.unfocus();
    isSearching.value = true;
    try {
      final response = await apiRepository.getRecipesComplexSearch(
        query: query,
      );
      if (response != null) {
        final searchResponse = SearchRecipesResponse.fromJson(response);
        searchResults.assignAll(searchResponse.results ?? []);
      }
    } catch (e) {
      AppSnackbar.show(title: "Error", message: "Failed to fetch recipes: $e");
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> launchBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      AppSnackbar.show(title: "Error", message: "Could not launch $url");
    }
  }

  Future<void> getDynamicFoodArticles() async {
    isLoadingArticles.value = true;
    try {
      final randomKeyword = (articleKeywords..shuffle()).first;
      final response = await apiRepository.getFoodArticles(query: randomKeyword);

      if (response != null && response['articles'] != null) {
        final List<dynamic> articles = response['articles'];
        if (articles.isNotEmpty) {
          foodArticles.assignAll(articles);
          return;
        }
      }

      _setFallbackArticles();
    } catch (e) {
      debugPrint("Error fetching dynamic food articles: $e");
      _setFallbackArticles();
    } finally {
      isLoadingArticles.value = false;
    }
  }

  void _setFallbackArticles() {
    foodArticles.assignAll([
      {
        'title': '10 Healthy Breakfast Ideas for a Productive Day',
        'image': 'https://images.unsplash.com/photo-1494390248081-4e521a5940db?q=80&w=1000&auto=format&fit=crop',
        'link': 'https://www.healthline.com/nutrition/healthy-breakfast-ideas',
      },
      {
        'title': 'Mastering Italian Cuisine: The Basics You Need to Know',
        'image': 'https://images.unsplash.com/photo-1498579150354-977475b7ea0b?q=80&w=1000&auto=format&fit=crop',
        'link': 'https://www.bonappetit.com/test-kitchen/how-to/article/italian-cooking-basics',
      },
      {
        'title': 'The Secret to Perfect Sushi Rice Every Single Time',
        'image': 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=1000&auto=format&fit=crop',
        'link': 'https://www.japancentre.com/en/recipes/10-how-to-make-perfect-sushi-rice',
      },
    ]);
  }

  Future<void> getRecommendedRecipes() async {
    isLoadingRecommended.value = true;
    try {
      final response = await apiRepository.getRandomRecipes(number: 2);
      if (response != null && response['recipes'] != null) {
        recommendedRecipes.assignAll(response['recipes'] ?? []);
      }
    } catch (e) {
      debugPrint("Error fetching recommended recipes: $e");
    } finally {
      isLoadingRecommended.value = false;
    }
  }

  Future<void> checkAndShowFingerprintReminder() async {
    await session.loadFingerprint();
    if (session.isFingerprintEnabled.value) return;
    final lastReminder = await session.dataSessionUtil
        .getLastFingerprintReminder();
    final now = DateTime.now().millisecondsSinceEpoch;
    if (lastReminder == null) {
      openEnabledFingerprintDialog(Get.context!);
    } else {
      final differenceInHours = (now - lastReminder) / (1000 * 60 * 60);
      if (differenceInHours >= 48) {
        openEnabledFingerprintDialog(Get.context!);
      }
    }
  }

  void openEnabledFingerprintDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ViewDialogUtil().showConfirmDialog(
      title: l10n.stEnableFingerprintNowTitle,
      icon: Icons.fingerprint,
      context: context,
      message: l10n.stEnableFingerprintNowMessage,
      positiveTitle: l10n.yesBtn,
      negativeTitle: l10n.stRemindMeLaterBtn,
      onPositiveClick: () {
        session.dataSessionUtil.setLastFingerprintReminder(
          DateTime.now().millisecondsSinceEpoch,
        );
        Get.toNamed('/security');
      },
      onNegativeClick: () {
        session.dataSessionUtil.setLastFingerprintReminder(
          DateTime.now().millisecondsSinceEpoch,
        );
        Navigator.of(context).pop();
        AppSnackbar.show(
          title: l10n.stInfo,
          message: l10n.stRemindMeLaterMessage,
        );
      },
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    searchResults.clear();
    recommendedRecipes.clear();
    autoCompleteResults.clear();
    isSearching.value = false;
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}
